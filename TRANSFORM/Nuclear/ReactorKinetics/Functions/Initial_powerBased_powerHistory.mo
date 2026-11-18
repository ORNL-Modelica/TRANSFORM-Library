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
  // Each interval: power linear from P0 at its start to P1 at its end, over dt
  Real dt;
  Real P0;
  Real P1;
  Real x "lambda*dt";
  Real elamdt "exp(-lambda*dt)";
  Real f1 "1 - exp(-x)";
  Real q "1 - (1 - exp(-x))/x";
  // With decay heat in the history: decay power at an interval's end = A + B*P1
  Real A;
  Real B;
algorithm
  // Each update below is the exact solution of der(C) = betas/Lambda*P - lambdas*C (and of
  // der(E) = efs*P - lambdas_dh*E) over one interval on which the fission power is linear,
  // written in the interval's own time: C1 = C0*exp(-x) + k/lambda*(P0*(1 - exp(-x)) + (P1 - P0)*q(x)),
  // x = lambda*dt. It holds for any dt >= 0: a repeated time (a step in power) leaves C unchanged.
  // Small x uses the series of f1 and q, which the direct forms lose to round-off.
  // With decay heat in the history (includeDH), the history's power is fission plus decay power.
  // The decay power at an interval's end is linear in its end fission power P1, A + B*P1, so P1
  // is solved for directly: P1 = (Q_total - A)/(1 + B).
  Cs := Cs_0;
  Es := Es_0;
  if nT > 0 then
    // (if-statements here: Dymola cannot generate code for an array comprehension inside an
    // if-expression in a function)
    if includeDH then
      Q_fission[1] := Q_total[1] - sum({lambdas_dh[j]*Es_0[j] for j in 1:nDH});
    else
      Q_fission[1] := Q_total[1];
    end if;
    assert(Q_fission[1] >= -1e-9*abs(Q_total[1]), "Power history: the first point's power is below the decay power of Es_0");
  end if;
  for i in 1:nT - 1 loop
    dt := max(0, t[i + 1] - t[i]);
    P0 := Q_fission[i];
    if includeDH then
      A := 0;
      B := 0;
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
        A := A + lambdas_dh[j]*Es[j]*elamdt + efs[j]*P0*(f1 - q);
        B := B + efs[j]*q;
      end for;
      P1 := (Q_total[i + 1] - A)/(1 + B);
      assert(P1 >= -1e-9*abs(Q_total[i + 1]), "Power history: at t = " + String(t[i + 1]) +
        " s the power is below the decay power, so the fission power would be negative");
      Q_fission[i + 1] := max(0, P1);
    else
      Q_fission[i + 1] := Q_total[i + 1];
    end if;
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
end Initial_powerBased_powerHistory;
