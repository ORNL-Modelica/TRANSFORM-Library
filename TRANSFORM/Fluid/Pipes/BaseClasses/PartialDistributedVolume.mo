within TRANSFORM.Fluid.Pipes.BaseClasses;
partial model PartialDistributedVolume
  "Base class for distributed 1-D volume models"
  import Modelica.Fluid.Types.Dynamics;
  import Modelica.Media.Interfaces.Choices.IndependentVariables;
  import TRANSFORM.Math.fillArray_1D;

  replaceable package Medium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium properties"
    annotation (choicesAllMatching=true);

  parameter Integer nV(min=1) = 1 "Number of discrete volumes";

  // Inputs provided to the volume model
  input SI.Volume Vs[nV](min=0) "Discretized volumes"
    annotation (Dialog(group="Inputs"));

  // Initialization
  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
    "Formulation of energy balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics massDynamics=energyDynamics "Formulation of mass balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  final parameter Dynamics substanceDynamics=massDynamics
    "Formulation of substance balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics traceDynamics=massDynamics
    "Formulation of trace substance balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));

  parameter SI.AbsolutePressure[nV] ps_start=fill(Medium.p_default, nV)
    "Pressure" annotation (Dialog(tab="Initialization", group=
          "Start Value: Absolute Pressure"));
  parameter Boolean use_Ts_start=true "Use T_start if true, otherwise h_start"
    annotation (Evaluate=true, Dialog(tab="Initialization", group=
          "Start Value: Temperature"));
  parameter SI.Temperature Ts_start[nV]=fill(Medium.T_default, nV)
    "Temperature" annotation (Evaluate=true, Dialog(
      tab="Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start));
  parameter SI.SpecificEnthalpy[nV] hs_start={Medium.specificEnthalpy_pTX(
      ps_start[i],
      Ts_start[i],
      Xs_start[i, :]) for i in 1:nV} "Specific enthalpy" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start));
  parameter SI.MassFraction Xs_start[nV,Medium.nX]=fillArray_1D(Medium.X_default,
      nV) "Mass fraction" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Species Mass Fraction",
      enable=Medium.nXi > 0));
  parameter SIadd.ExtraProperty Cs_start[nV,Medium.nC]=fill(
      0,
      nV,
      Medium.nC) "Mass-Specific value" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Trace Substances",
      enable=Medium.nC > 0));

  Medium.BaseProperties[nV] mediums(
    each preferredMediumStates=true,
    p(start=ps_start),
    h(start=if not use_Ts_start then hs_start else {Medium.specificEnthalpy_pTX(
          ps_start[i],
          Ts_start[i],
          Xs_start[i, 1:Medium.nXi]) for i in 1:nV}),
    T(start=if use_Ts_start then Ts_start else {Medium.temperature_phX(
          ps_start[i],
          hs_start[i],
          Xs_start[i, 1:Medium.nXi]) for i in 1:nV}),
    Xi(start=Xs_start[:, 1:Medium.nXi]));

  // Total quantities
  SI.Mass ms[nV] "Mass";
  SI.Energy Us[nV] "Internal energy";
  SI.Mass mXis[nV,Medium.nXi] "Species mass";
  SIadd.ExtraPropertyExtrinsic mCs[nV,Medium.nC] "Trace substance extrinsic value";
  SI.Mass[nV,Medium.nC] mCs_scaled
    "Scaled trace substance mass for improved numerical stability";

  // C has the additional parameter because it is not included in the medium
  // i.e.,Xi has medium[:].Xi but there is no variable medium[:].C
  SIadd.ExtraProperty Cs[nV,Medium.nC](each stateSelect=StateSelect.prefer, start=
        Cs_start) "Trace substance mass-specific value";

  // Mass Balance
  SI.MassFlowRate mbs[nV]
    "Mass flow rate balances across volume interfaces (e.g., enthalpy flow, diffusion) and source/sinks within volumes";

  // Energy Balance
  SI.HeatFlowRate Ubs[nV]
    "Energy sources across volume interfaces (e.g., thermal diffusion) and source/sinks within volumes";

  // Species Balance
  SI.MassFlowRate mXibs[nV,Medium.nXi]
    "Species mass flow rates across volume interfaces and source/sinks within volumes";

  // Trace Balance
  SIadd.ExtraPropertyFlowRate mCbs[nV,Medium.nC]
    "Trace flow rate across volume interfaces (e.g., diffusion) and source/sinks within volumes (e.g., chemical reactions, external convection)";

protected
  parameter Boolean initialize_p=not Medium.singleState
    "= true to set up initial equations for pressure";

initial equation

  // Mass Balance
  if massDynamics == Dynamics.FixedInitial then
    if initialize_p then
      mediums.p = ps_start;
    end if;
  elseif massDynamics == Dynamics.SteadyStateInitial then
    if initialize_p then
      der(mediums.p) = zeros(nV);
    end if;
  end if;

  // Energy Balance
  if energyDynamics == Dynamics.FixedInitial then
    /*
    if use_T_start then
      mediums.T = Ts_start;
    else
      mediums.h = hs_start;
    end if;
    */
    if Medium.ThermoStates == IndependentVariables.ph or Medium.ThermoStates
         == IndependentVariables.phX then
      mediums.h = hs_start;
    else
      mediums.T = Ts_start;
    end if;
  elseif energyDynamics == Dynamics.SteadyStateInitial then
    /*
    if use_T_start then
      der(mediums.T) = zeros(nV);
    else
      der(mediums.h) = zeros(nV);
    end if;
    */
    if Medium.ThermoStates == IndependentVariables.ph or Medium.ThermoStates
         == IndependentVariables.phX then
      der(mediums.h) = zeros(nV);
    else
      der(mediums.T) = zeros(nV);
    end if;
  end if;

  // Species Balance
  if substanceDynamics == Dynamics.FixedInitial then
    mediums.Xi = Xs_start[:, 1:Medium.nXi];
  elseif substanceDynamics == Dynamics.SteadyStateInitial then
    der(mediums.Xi) = zeros(nV, Medium.nXi);
  end if;

  // Trace Balance
  if traceDynamics == Dynamics.FixedInitial then
    Cs = Cs_start;
  elseif traceDynamics == Dynamics.SteadyStateInitial then
    der(mCs) = zeros(nV, Medium.nC);
  end if;

equation
  assert(not (energyDynamics <> Dynamics.SteadyState and massDynamics ==
    Dynamics.SteadyState) or Medium.singleState,
    "Bad combination of dynamics options and Medium not conserving mass if fluidVolumes are fixed.");

  // Total Quantities
  for i in 1:nV loop
    ms[i] = Vs[i]*mediums[i].d;
    Us[i] = ms[i]*mediums[i].u;
    mXis[i, :] = ms[i]*mediums[i].Xi;
    mCs[i, :] = ms[i] .* Cs[i, :];
  end for;

  // Mass Balance
  if massDynamics == Dynamics.SteadyState then
    for i in 1:nV loop
      0 = mbs[i];
    end for;
  else
    for i in 1:nV loop
      der(ms[i]) = mbs[i];
    end for;
  end if;

  // Energy Balance
  if energyDynamics == Dynamics.SteadyState then
    for i in 1:nV loop
      0 = Ubs[i];
    end for;
  else
    for i in 1:nV loop
      der(Us[i]) = Ubs[i];
    end for;
  end if;

  // Species Balance
  if substanceDynamics == Dynamics.SteadyState then
    for i in 1:nV loop
      zeros(Medium.nXi) = mXibs[i, :];
    end for;
  else
    for i in 1:nV loop
      der(mXis[i, :]) = mXibs[i, :];
    end for;
  end if;

  // Trace Balance
  if traceDynamics == Dynamics.SteadyState then
    for i in 1:nV loop
      zeros(Medium.nC) = mCbs[i, :];
    end for;
  else
    for i in 1:nV loop
      der(mCs_scaled[i, :]) = mCbs[i, :] ./ Medium.C_nominal;
      mCs[i, :] = mCs_scaled[i, :] .* Medium.C_nominal;
    end for;
  end if;

  annotation (Documentation(info="<html>
<p>The following boundary flow and source terms are part of the energy balance and must be specified in an extending class: </p>
<ul>
<li>Hb_flows[nVs], enthalpy flow rate (e.g., moving solid through boundaries)</li>
<li>Qb_flows[nVs], heat flow term (e.g., conductive heat flows across discritized boundaries)</li>
<li>Qb_volumes[nVs], sources of energy that are calculated from volume element state (e.g., convection or internal heat generation)</li>
</ul>
<p>The following Inputs need to be set in an extending class to complete the model: </p>
<ul>
<li>Vs[nVs], distributed volumes</li>
</ul>
</html>"));
end PartialDistributedVolume;
