within TRANSFORM.Nuclear.ReactorKinetics.Functions;
function Initial_powerBased_powerHistory
  "Determines the initial neutron precursor power-based concentration and decay heat based on power history"
  // Source: TRACE Manual
  input SI.Power[:,2] history "Power history up to simulation time=0, [t,Q]";
  input TRANSFORM.Units.InverseTime[:] lambdas
    "Decay constants for each precursor group";
  input TRANSFORM.Units.NonDim[size(lambdas, 1)] alphas
    "Normalized precursor fractions [betas = alphas*Beta]";
  input TRANSFORM.Units.NonDim Beta "Effective delayed neutron fraction";
  input SI.Time Lambda "Prompt neutron generation time";
  input TRANSFORM.Units.InverseTime[:] lambdas_dh
    "Decay constants for each group";
  input Units.NonDim efs[size(lambdas_dh, 1)]
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
  // Linear fit over interval from i to i+1:
  // power = a + b*t
  Real dt;
  Real a;
  Real b;
  Real elamdt;
  Real elamdt_dh;
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
  // der(E) = efs*P - lambdas_dh*E) over one interval on which the power is linear, P = a + b*t
  // (exact for intervals of 1 s or more: dt is clamped below that).
  if not includeDH then
    // Decay-heat is not included in power history.
    Cs := Cs_0;
    Es := Es_0;
        for i in 1:nT - 1 loop
      dt := max(1, t[i + 1] - t[i]);
      a := (t[i + 1]*Q_fission[i] - t[i]*Q_fission[i + 1])/dt;
      b := (Q_fission[i + 1] - Q_fission[i])/dt;
      // Delayed-neutron precursor group
      for j in 1:nI loop
        elamdt := min(1, max(0, exp(-lambdas[j]*dt)));
        Cs[j] := max(0, Cs[j]*elamdt + betas[j]/(lambdas[j]*Lambda)*(a*(1 -
          elamdt) + b/lambdas[j]*(lambdas[j]*t[i + 1] - 1 - (lambdas[j]*t[i] - 1)
          *elamdt)));
      end for;
      // Decay-heat group
      for j in 1:nDH loop
        elamdt_dh := min(1, max(0, exp(-lambdas_dh[j]*dt)));
        Es[j] :=max(0, Es[j]*elamdt_dh + efs[j]/(lambdas_dh[j])*(a*(1
           - elamdt_dh) + b/lambdas_dh[j]*(lambdas_dh[j]*t[i + 1] - 1
           - (lambdas_dh[j]*t[i] - 1)*elamdt_dh)));
      end for;
        end for;
  else
  // Decay-heat is included in power history. Therefore solution is iterative.
  // Iterate to convergence
  while error > tol and iter < iterMax loop
    Cs := Cs_0;
    Es := Es_0;
      for i in 1:nT - 1 loop
      dt := max(1, t[i + 1] - t[i]);
      a := (t[i + 1]*Q_fission[i] - t[i]*Q_fission[i + 1])/dt;
      b := (Q_fission[i + 1] - Q_fission[i])/dt;
      // Delayed-neutron precursor group
      for j in 1:nI loop
        elamdt := min(1, max(0, exp(-lambdas[j]*dt)));
        Cs[j] := max(0, Cs[j]*elamdt + betas[j]/(lambdas[j]*Lambda)*(a*(1 -
          elamdt) + b/lambdas[j]*(lambdas[j]*t[i + 1] - 1 - (lambdas[j]*t[i] - 1)
          *elamdt)));
      end for;
      // Decay-heat group
      for j in 1:nDH loop
        elamdt_dh := min(1, max(0, exp(-lambdas_dh[j]*dt)));
        Es[j] :=max(0, Es[j]*elamdt_dh + efs[j]/(lambdas_dh[j])*(a*(1
             - elamdt_dh) + b/lambdas_dh[j]*(lambdas_dh[j]*t[i + 1] - 1
             - (lambdas_dh[j]*t[i] - 1)*elamdt_dh)));
      end for;
      // Determine error
      eta_new := sum({lambdas_dh[j]*Es[j] for j in 1:nDH})/Q_fission[i+1];
      error_i[i+1] := eta_new - eta[i + 1];
      // Update values
      eta[i + 1] := eta_new;
      Q_fission[i + 1] := Q_total[i + 1]/(1 + eta[i + 1]);
      Q_decay[i + 1] := eta[i + 1]*Q_fission[i + 1];
      iter :=iter + 1;
    end for;
    error :=sum(abs(error_i));
  end while;
  assert(iter<iterMax, "Decay heat fraction for operating history did not converge");
  end if;
end Initial_powerBased_powerHistory;
