within TRANSFORM.Nuclear.ReactorKinetics.Functions;
function Initial_powerBased_powerHistory
  "Determines the initial neutron precursor power-based concentration and decay heat based on power history"
  // Source: TRACE Manual
  input SI.Power[:,2] history "Power history up to simulation time=0, [t,Q]";
  input SItf.InverseTime[:] lambdas
    "Decay constants for each precursor group";
  input SItf.NonDim[size(lambdas, 1)] alphas
    "Normalized precursor fractions [betas = alphas*Beta]";
  input SItf.NonDim Beta "Effective delayed neutron fraction";
  input SI.Time Lambda "Prompt neutron generation time";
  input SItf.InverseTime[:] lambdas_dh
    "Decay constants for each group";
  input SItf.NonDim efs[size(lambdas_dh, 1)]
    "Decay-heat fraction of fission power";
  input Boolean includeDH = false "=true if power history includes decay heat";
  input SI.Power[size(lambdas, 1)] Cs_0=fill(0, size(lambdas, 1))
    "Precursor concentration at history time = 0";
  input SI.Energy[size(lambdas_dh, 1)] Es_0=fill(0, size(lambdas_dh, 1))
    "Decay-heat concentration at history time = 0";
  output SI.Power[size(lambdas, 1)] Cs;
  output SI.Energy[size(lambdas_dh, 1)] Es;
protected
  Integer nT=size(history, 1) "# of time history points";
  Integer nI=size(lambdas, 1) "# of delayed-neutron precursors groups";
  Integer nDH=size(lambdas_dh, 1) "# of decay-heat groups";
  Real betas[nI]=alphas*Beta;
  // Element by element, not history[:, 1]: OpenModelica 1.27.1 passes an empty history
  // (fill(0, 0, 2), the default in the point-kinetics models) as a 1-D {}, and the
  // slice then stops the simulation at start-up. Same values.
  Real t[nT]={history[i, 1] for i in 1:nT} "Time";
  Real Q_total[nT]={history[i, 2] for i in 1:nT} "Total Power (fission + decay)";
  Real Q_fission[nT] "Fission power";
  Real Q_decay[nT] "Decay power";
  Real eta[nT]=zeros(nT);
  Real eta_new;
  // Each interval: power linear from P0 at its start to P1 at its end, over dt
  Real dt;
  Real P0;
  Real P1;
  Real x "lambda*dt";
  Real elamdt "exp(-lambda*dt)";
  Real f1 "1 - exp(-x)";
  Real q "1 - (1 - exp(-x))/x";
  // For iterative process
  Real error_i[nT]=zeros(nT);
  Real error=1;
  Real tol=1e-10;
  Integer iter=0;
  Integer iterMax=30;
algorithm
  // Initial guesses. Without decay heat in the history, the history is all fission power.
  for i in 1:nT loop
    if includeDH then
      eta[i] := sum({lambdas_dh[j]*Es_0[j] for j in 1:nDH})/max(1,Q_total[i]);
    else
      eta[i] := 0;
    end if;
    Q_fission[i] := Q_total[i]/(1 + eta[i]);
    Q_decay[i] := eta[i]*Q_fission[i];
  end for;
  // Each update below is the exact solution of der(C) = betas/Lambda*P - lambdas*C (and of
  // der(E) = efs*P - lambdas_dh*E) over one interval on which the power is linear, written in
  // the interval's own time: C1 = C0*exp(-x) + k/lambda*(P0*(1 - exp(-x)) + (P1 - P0)*q(x)),
  // x = lambda*dt. It holds for any dt >= 0: a repeated time (a step in power) leaves C unchanged.
  // Small x uses the series of f1 and q, which the direct forms lose to round-off.
  if not includeDH then
    // Decay-heat is not included in power history.
    Cs := Cs_0;
    Es := Es_0;
    for i in 1:nT - 1 loop
      dt := max(0, t[i + 1] - t[i]);
      P0 := Q_fission[i];
      P1 := Q_fission[i + 1];
      // Delayed-neutron precursor group
      for j in 1:nI loop
        x := lambdas[j]*dt;
        elamdt := exp(-x);
        if x < 1e-3 then
          f1 := x*(1 - x/2*(1 - x/3*(1 - x/4)));
          q := x/2*(1 - x/3*(1 - x/4*(1 - x/5)));
        else
          f1 := 1 - elamdt;
          q := 1 - f1/x;
        end if;
        Cs[j] := max(0, Cs[j]*elamdt + betas[j]/(lambdas[j]*Lambda)*(P0*f1 + (P1 - P0)*q));
      end for;
      // Decay-heat group
      for j in 1:nDH loop
        x := lambdas_dh[j]*dt;
        elamdt := exp(-x);
        if x < 1e-3 then
          f1 := x*(1 - x/2*(1 - x/3*(1 - x/4)));
          q := x/2*(1 - x/3*(1 - x/4*(1 - x/5)));
        else
          f1 := 1 - elamdt;
          q := 1 - f1/x;
        end if;
        Es[j] := max(0, Es[j]*elamdt + efs[j]/lambdas_dh[j]*(P0*f1 + (P1 - P0)*q));
      end for;
    end for;
  else
    // Decay-heat is included in power history. Therefore solution is iterative: each pass
    // recomputes the fission power at every point from the decay heat of the pass before.
    while error > tol and iter < iterMax loop
      Cs := Cs_0;
      Es := Es_0;
      for i in 1:nT - 1 loop
        dt := max(0, t[i + 1] - t[i]);
        P0 := Q_fission[i];
        P1 := Q_fission[i + 1];
        // Delayed-neutron precursor group
        for j in 1:nI loop
          x := lambdas[j]*dt;
        elamdt := exp(-x);
        if x < 1e-3 then
          f1 := x*(1 - x/2*(1 - x/3*(1 - x/4)));
          q := x/2*(1 - x/3*(1 - x/4*(1 - x/5)));
        else
          f1 := 1 - elamdt;
          q := 1 - f1/x;
        end if;
          Cs[j] := max(0, Cs[j]*elamdt + betas[j]/(lambdas[j]*Lambda)*(P0*f1 + (P1 - P0)*q));
        end for;
        // Decay-heat group
        for j in 1:nDH loop
          x := lambdas_dh[j]*dt;
        elamdt := exp(-x);
        if x < 1e-3 then
          f1 := x*(1 - x/2*(1 - x/3*(1 - x/4)));
          q := x/2*(1 - x/3*(1 - x/4*(1 - x/5)));
        else
          f1 := 1 - elamdt;
          q := 1 - f1/x;
        end if;
          Es[j] := max(0, Es[j]*elamdt + efs[j]/lambdas_dh[j]*(P0*f1 + (P1 - P0)*q));
        end for;
        // Decay-heat fraction at the interval's end; none where there is no fission power
        eta_new := if Q_fission[i + 1] > 0 then sum({lambdas_dh[j]*Es[j] for j in 1:nDH})/Q_fission[i + 1] else 0;
        error_i[i + 1] := eta_new - eta[i + 1];
        eta[i + 1] := eta_new;
        Q_fission[i + 1] := Q_total[i + 1]/(1 + eta[i + 1]);
        Q_decay[i + 1] := eta[i + 1]*Q_fission[i + 1];
      end for;
      error := sum(abs(error_i));
      iter := iter + 1;
    end while;
    assert(error <= tol, "Decay heat fraction for operating history did not converge");
  end if;
end Initial_powerBased_powerHistory;
