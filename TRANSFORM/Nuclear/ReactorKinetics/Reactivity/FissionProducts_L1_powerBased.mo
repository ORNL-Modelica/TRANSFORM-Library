within TRANSFORM.Nuclear.ReactorKinetics.Reactivity;
model FissionProducts_L1_powerBased

  import Modelica.Fluid.Types.Dynamics;

  // Fission products
  parameter Integer nV=1 "# of discrete volumes";
  parameter Integer nC=0 "# of fission products"
    annotation (Dialog(tab="Fission Products"));
  parameter Integer nFS=0 "# of fission product sources"
    annotation (Dialog(tab="Fission Products"));
  parameter Real[nC,nC] parents=fill(
      0,
      nC,
      nC)
    "Matrix of parent sources (sum(column) = 1 or 0) for each fission product 'daughter'. Row is daughter, Column is parent."
    annotation (Dialog(tab="Fission Products"));

  input SIadd.NonDim fissionSource[nFS]=fill(1/nFS, nFS)
    "Source of fissile material fractional composition (sum=1)"
    annotation (Dialog(tab="Fission Products", group="Inputs"));
  input SI.MacroscopicCrossSection SigmaF=1
    "Macroscopic fission cross-section of fissile material"
    annotation (Dialog(tab="Fission Products", group="Inputs"));
  input SI.Area[nC] sigmaA=fill(0, nC)
    "Microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(tab="Fission Products", group="Inputs"));

  input Real fissionYield[nC,nFS]=fill(
      0,
      nC,
      nFS)
    "# fission product atoms yielded per fission per fissile source [#/fission]"
    annotation (Dialog(tab="Fission Products", group="Inputs"));
  input TRANSFORM.Units.InverseTime[nC] lambda=fill(0, nC)
    "Decay constants for each fission product"
    annotation (Dialog(tab="Fission Products", group="Inputs"));
  input SI.Energy w_near_decay[nC]=fill(0, nC)
    "Energy released per decay of each fission product [J/decay] (near field - e.g., beta)"
    annotation (Dialog(tab="Fission Products", group="Inputs"));
  input SI.Energy w_far_decay[nC]=fill(0, nC)
    "Energy released per decay of each fission product [J/decay] (far field - e.g., gamma)"
    annotation (Dialog(tab="Fission Products", group="Inputs"));

  input Units.NonDim nu_bar=2.4 "Neutrons per fission"
    annotation (Dialog(group="Inputs"));
  input SI.Energy w_f=200e6*1.6022e-19 "Energy released per fission"
    annotation (Dialog(group="Inputs"));

  input SI.Power Qs[nV]=fill(1e6/nV, nV)
    "Power determined from kinetics. Does not include fission product decay heat"
    annotation (Dialog(group="Inputs"));
  input SI.Volume[nV] Vs=fill(0.1, nV)
    "Volume for fisson product concentration basis"
    annotation (Dialog(group="Inputs"));

  parameter SIadd.ExtraPropertyExtrinsic mCs_start[nV,nC]=fill(
      0,
      nV,
      nC) "Number of atoms" annotation (Dialog(tab="Initialization"));

  parameter Dynamics traceDynamics=Dynamics.DynamicFreeInitial
    "Formulation of trace substance balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Real mC_nominal[nC]=fill(1e-6, nC)
    "Nominal atoms. For numeric purposes only."
    annotation (Dialog(tab="Advanced"));

  output SIadd.NonDim rhos[nV,nC] "Fission product reactivity feedback"
    annotation (Dialog(group="Outputs", enable=false));
  output SI.Power Qs_near[nV]
    "Near field (e.g, beta) power released from fission product decay"
    annotation (Dialog(
      group="Outputs",
      enable=false));
  output SI.Power Qs_far[nV]
    "Far field (e.g., gamma) power released from fission product decay"
    annotation (Dialog(
      group="Outputs",
      enable=false));

  SIadd.NeutronFlux phi[nV] "Neutron flux";
  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens
    "Generation rate of fission products [atoms/s]";
  SIadd.ExtraPropertyExtrinsic mCs[nV,nC](each stateSelect=StateSelect.prefer,
      start=mCs_start) "Number of atoms";
  SIadd.ExtraPropertyExtrinsic[nV,nC] mCs_scaled
    "Scaled number of atmos for improved numerical stability";

  parameter Integer nC_add=0 "# of additional substances"
    annotation (Dialog(tab="Additional Reactivity"));
  input SIadd.ExtraPropertyExtrinsic mCs_add[nV,nC_add] = fill(0,nV,nC_add) "Number of atoms" annotation(Dialog(tab="Additional Reactivity",group="Inputs"));
  input SI.Volume[nV] Vs_add=fill(0.1, nV)
    "Volume for fisson product concentration basis"
    annotation (Dialog(tab="Additional Reactivity",group="Inputs"));
  input SI.Area[nC_add] sigmaA_add=fill(0, nC_add)
    "Microscopic absorption cross-section for reactivity feedback"
    annotation (Dialog(tab="Additional Reactivity", group="Inputs"));
  output SIadd.ExtraPropertyFlowRate[nV,nC_add] mC_gens_add
    "Generation rate of additional substances [atoms/s] (e.g., Boron in fluid)"
    annotation (Dialog(tab="Additional Reactivity",group="Outputs", enable=false));
  output SIadd.NonDim rhos_add[nV,nC_add] "Additional subtances reactivity feedback"
    annotation (Dialog(tab="Additional Reactivity",group="Outputs", enable=false));

protected
  SI.Power Qs_near_i[nV,nC]
    "Near field (e.g, beta) power released from fission product decay (per species per volume)";
  SI.Power Qs_far_i[nV,nC]
    "Far field (e.g., gamma) power released from fission product decay (per species per volume)";

initial equation
  if traceDynamics == Dynamics.FixedInitial then
    mCs = mCs_start;
  elseif traceDynamics == Dynamics.SteadyStateInitial then
    der(mCs) = zeros(nV, nC);
  end if;

equation

  if traceDynamics == Dynamics.SteadyState then
    for i in 1:nV loop
      zeros(nC) = mC_gens[i, :];
    end for;
  else
    for i in 1:nV loop
      der(mCs_scaled[i, :]) = mC_gens[i, :] ./ mC_nominal;
      mCs[i, :] = mCs_scaled[i, :] .* mC_nominal;
    end for;
  end if;

  for i in 1:nV loop
    phi[i] = Qs[i]/(w_f*SigmaF)/Vs[i];
    for j in 1:nC loop
      mC_gens[i, j] = Qs[i]/w_f*sum({fissionSource[k]*fissionYield[j, k] for k in
            1:nFS}) - lambda[j]*mCs[i, j] + sum(lambda .* mCs[i, :] .* parents[
        j, :]) - sigmaA[j]*mCs[i, j]*Qs[i]/(w_f*SigmaF)/Vs[i];
      rhos[i, j] = -sigmaA[j]*mCs[i, j]/(nu_bar*SigmaF)/Vs[i];
    end for;
  end for;

  // Decay power from fission product decay
  Qs_near_i ={{w_near_decay[j]*lambda[j]*mCs[i, j] for j in 1:nC} for i in 1:nV};
  Qs_far_i ={{w_far_decay[j]*lambda[j]*mCs[i, j] for j in 1:nC} for i in 1:nV};

  Qs_near = {sum(Qs_near_i[i, :]) for i in 1:nV};
  Qs_far = {sum(Qs_far_i[i, :]) for i in 1:nV};

  // Additional substances from another source
  for i in 1:nV loop
    for j in 1:nC_add loop
      mC_gens_add[i, j] = - sigmaA_add[j]*mCs_add[i, j]*Qs[i]/(w_f*SigmaF)/Vs_add[i];
      rhos_add[i, j] = -sigmaA_add[j]*mCs_add[i, j]/(nu_bar*SigmaF)/Vs_add[i];
    end for;
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-38,28},{44,-28}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="FP")}));
end FissionProducts_L1_powerBased;
