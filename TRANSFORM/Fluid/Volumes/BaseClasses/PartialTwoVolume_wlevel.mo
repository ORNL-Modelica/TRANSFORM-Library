within TRANSFORM.Fluid.Volumes.BaseClasses;
partial model PartialTwoVolume_wlevel "Base class for volume models"

  import Modelica.Fluid.Types.Dynamics;
  import Modelica.Media.Interfaces.Choices.IndependentVariables;

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium "Medium properties"
    annotation (choicesAllMatching=true);

  // Initialization
  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
    "Formulation of energy balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics massDynamics=energyDynamics "Formulation of mass balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics substanceDynamics=massDynamics
    "Formulation of substance balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics traceDynamics=massDynamics
    "Formulation of trace substance balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));

  parameter SI.Height level_start=0 annotation(Dialog(tab="Initialization"));
  parameter Medium.AbsolutePressure p_liquid_start=Medium.p_default "Pressure" annotation (
     Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));
  parameter Medium.AbsolutePressure p_vapor_start=Medium.p_default "Pressure" annotation (
     Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));
  parameter Boolean use_T_start=true "Use T_start if true, otherwise h_start"
    annotation (Evaluate=true, Dialog(tab="Initialization", group=
          "Start Value: Temperature"));
  parameter Medium.Temperature T_liquid_start=Medium.T_default "Temperature" annotation (
      Evaluate=true, Dialog(
      tab="Initialization",
      group="Start Value: Temperature",
      enable=use_T_start));
  parameter Medium.Temperature T_vapor_start=Medium.T_default "Temperature" annotation (
      Evaluate=true, Dialog(
      tab="Initialization",
      group="Start Value: Temperature",
      enable=use_T_start));
  parameter Medium.SpecificEnthalpy h_liquid_start=Medium.specificEnthalpy_pTX(
      p_liquid_start,
      T_liquid_start,
      X_liquid_start) "Specific enthalpy" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_T_start));
  parameter Medium.SpecificEnthalpy h_vapor_start=Medium.specificEnthalpy_pTX(
      p_vapor_start,
      T_vapor_start,
      X_vapor_start) "Specific enthalpy" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_T_start));
  parameter SI.MassFraction X_liquid_start[Medium.nX]=Medium.X_default "Mass fraction"
    annotation (Dialog(
      tab="Initialization",
      group="Start Value: Species Mass Fraction",
      enable=Medium.nXi > 0));
  parameter SI.MassFraction X_vapor_start[Medium.nX]=Medium.X_default "Mass fraction"
    annotation (Dialog(
      tab="Initialization",
      group="Start Value: Species Mass Fraction",
      enable=Medium.nXi > 0));
  parameter SI.MassFraction C_liquid_start[Medium.nC]=fill(0, Medium.nC)
    "Mass fraction" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Trace Substances Mass Fraction",
      enable=Medium.nC > 0));
  parameter SI.MassFraction C_vapor_start[Medium.nC]=fill(0, Medium.nC)
    "Mass fraction" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Trace Substances Mass Fraction",
      enable=Medium.nC > 0));

//   Medium.BaseProperties medium_liquid(
//     each preferredMediumStates=true,
//     p(start=p_liquid_start),
//     h(start=h_liquid_start),
//     T(start=Medium.temperature_phX(
//           p_liquid_start,
//           h_liquid_start,
//           X_liquid_start[1:Medium.nXi])),
//     Xi(start=X_liquid_start[1:Medium.nXi]));
//
//   Medium.BaseProperties medium_vapor(
//     each preferredMediumStates=true,
//     p(start=p_vapor_start),
//     h(start=h_vapor_start),
//     T(start=Medium.temperature_phX(
//           p_vapor_start,
//           h_vapor_start,
//           X_vapor_start[1:Medium.nXi])),
//     Xi(start=X_vapor_start[1:Medium.nXi]));

  Medium.BaseProperties medium_liquid(
    each preferredMediumStates=true,
    p(start=p_liquid_start),
    h(start=if not use_T_start then h_liquid_start else Medium.specificEnthalpy_pTX(
          p_liquid_start,
          T_liquid_start,
          X_liquid_start[1:Medium.nXi])),
    T(start=if use_T_start then T_liquid_start else Medium.temperature_phX(
          p_liquid_start,
          h_liquid_start,
          X_liquid_start[1:Medium.nXi])),
    Xi(start=X_liquid_start[1:Medium.nXi]),
    X(start=X_liquid_start),
    d(start=if use_T_start then Medium.density_pTX(
          p_liquid_start,
          T_liquid_start,
          X_liquid_start[1:Medium.nXi]) else Medium.density_phX(
          p_liquid_start,
          h_liquid_start,
          X_liquid_start[1:Medium.nXi])));

  Medium.BaseProperties medium_vapor(
    each preferredMediumStates=true,
    p(start=p_vapor_start),
    h(start=if not use_T_start then h_vapor_start else Medium.specificEnthalpy_pTX(
          p_vapor_start,
          T_vapor_start,
          X_vapor_start[1:Medium.nXi])),
    T(start=if use_T_start then T_vapor_start else Medium.temperature_phX(
          p_vapor_start,
          h_vapor_start,
          X_vapor_start[1:Medium.nXi])),
    Xi(start=X_vapor_start[1:Medium.nXi]),
    X(start=X_vapor_start),
    d(start=if use_T_start then Medium.density_pTX(
          p_vapor_start,
          T_vapor_start,
          X_vapor_start[1:Medium.nXi]) else Medium.density_phX(
          p_vapor_start,
          h_vapor_start,
          X_vapor_start[1:Medium.nXi])));

  // Inputs provided to the volume model
  input SI.Height level(start=level_start) = 0 "Liquid level" annotation(Dialog(group="Input Variables"));
  input SI.Volume V_vapor(min=0) "Vapor volume" annotation(Dialog(group="Input Variables"));

  // V_liquid or level is input but not both
  SI.Volume V_liquid(min=0) "Liquid volume";

  // Total quantities
  SI.Mass m_liquid "Mass";
  SI.InternalEnergy U_liquid "Internal energy";
  SI.Mass mXi_liquid[Medium.nXi] "Species mass";
  SI.Mass mC_liquid[Medium.nC] "Trace substance mass";
  SI.Mass[Medium.nC] mC_scaled_liquid "Scaled trace substance mass for improved numerical stability";

  SI.Mass m_vapor "Mass";
  SI.InternalEnergy U_vapor "Internal energy";
  SI.Mass mXi_vapor[Medium.nXi] "Species mass";
  SI.Mass mC_vapor[Medium.nC] "Trace substance mass";
  SI.Mass[Medium.nC] mC_scaled_vapor "Scaled trace substance mass for improved numerical stability";

  // C has the additional parameter because it is not included in the medium
  // i.e.,Xi has medium[:].Xi but there is no variable medium[:].C
  SI.MassFraction C_liquid[Medium.nC](stateSelect=StateSelect.prefer, start=C_liquid_start)
    "Trace substance mass fraction";
  SI.MassFraction C_vapor[Medium.nC](stateSelect=StateSelect.prefer, start=C_vapor_start)
    "Trace substance mass fraction";

  // Mass Balance
  SI.MassFlowRate mb_liquid "Mass flow rate source/sinks within volumes";
  SI.MassFlowRate mb_vapor "Mass flow rate source/sinks within volumes";

  // Energy Balance
  SI.HeatFlowRate Ub_liquid
    "Energy source/sinks within volumes (e.g., ohmic heating, external convection)";
  SI.HeatFlowRate Ub_vapor
    "Energy source/sinks within volumes (e.g., ohmic heating, external convection)";

  // Species Balance
  SI.MassFlowRate mXib_liquid[Medium.nXi]
    "Species mass flow rates source/sinks within volumes";
  SI.MassFlowRate mXib_vapor[Medium.nXi]
    "Species mass flow rates source/sinks within volumes";

  // Trace Balance
  SI.MassFlowRate mCb_liquid[Medium.nC]
    "Trace mass flow rate source/sinks within volumes (e.g., chemical reactions, external convection)";
  SI.MassFlowRate mCb_vapor[Medium.nC]
    "Trace mass flow rate source/sinks within volumes (e.g., chemical reactions, external convection)";

protected
  parameter Boolean initialize_p=not Medium.singleState
    "= true to set up initial equations for pressure";

initial equation

  // Mass Balance
  if massDynamics == Dynamics.FixedInitial then
    if initialize_p then
      medium_liquid.p = p_liquid_start;
      medium_vapor.p = p_vapor_start;
    end if;
    level = level_start;
  elseif massDynamics == Dynamics.SteadyStateInitial then
    if initialize_p then
      der(medium_liquid.p) = 0;
      der(medium_vapor.p) = 0;
    end if;
    der(level) = 0;
  end if;

  // Energy Balance
  if energyDynamics == Dynamics.FixedInitial then
    /*
    if use_T_start then
      medium.T = T_start;
    else
      medium.h = h_start;
    end if;
    */
    if Medium.ThermoStates == IndependentVariables.ph or Medium.ThermoStates
         == IndependentVariables.phX then
      medium_liquid.h = h_liquid_start;
      medium_vapor.h = h_vapor_start;
    else
      medium_liquid.T = T_liquid_start;
      medium_vapor.T = T_vapor_start;
    end if;
  elseif energyDynamics == Dynamics.SteadyStateInitial then
    /*
    if use_T_start then
      der(medium.T) = 0;
    else
      der(medium.h) = 0;
    end if;
    */
    if Medium.ThermoStates == IndependentVariables.ph or Medium.ThermoStates
         == IndependentVariables.phX then
      der(medium_liquid.h) = 0;
      der(medium_vapor.h) = 0;
    else
      der(medium_liquid.T) = 0;
      der(medium_vapor.T) = 0;
    end if;
  end if;

  // Species Balance
  if substanceDynamics == Dynamics.FixedInitial then
    medium_liquid.Xi = X_liquid_start[1:Medium.nXi];
    medium_vapor.Xi = X_vapor_start[1:Medium.nXi];
  elseif substanceDynamics == Dynamics.SteadyStateInitial then
    der(medium_liquid.Xi) = zeros(Medium.nXi);
    der(medium_vapor.Xi) = zeros(Medium.nXi);
  end if;

  // Trace Balance
  if traceDynamics == Dynamics.FixedInitial then
    C_liquid = C_liquid_start;
    C_vapor = C_vapor_start;
  elseif traceDynamics == Dynamics.SteadyStateInitial then
    der(mC_liquid) = zeros(Medium.nC);
    der(mC_vapor) = zeros(Medium.nC);
  end if;

equation
  assert(not (energyDynamics <> Dynamics.SteadyState and massDynamics ==
    Dynamics.SteadyState) or Medium.singleState,
    "Bad combination of dynamics options and Medium not conserving mass if fluidVolumes are fixed.");

  // Total Quantities
  m_liquid = V_liquid*medium_liquid.d;
  U_liquid = m_liquid*medium_liquid.u;
  mXi_liquid = m_liquid*medium_liquid.Xi;
  mC_liquid = m_liquid*C_liquid;

  m_vapor = V_vapor*medium_vapor.d;
  U_vapor = m_vapor*medium_vapor.u;
  mXi_vapor = m_vapor*medium_vapor.Xi;
  mC_vapor = m_vapor*C_vapor;

  // Mass Balance
  if massDynamics == Dynamics.SteadyState then
    0 = mb_liquid;
    0 = mb_vapor;
  else
    der(m_liquid) = mb_liquid;
    der(m_vapor) = mb_vapor;
  end if;

  // Energy Balance
  if energyDynamics == Dynamics.SteadyState then
    0 = Ub_liquid;
    0 = Ub_vapor;
  else
    der(U_liquid) = Ub_liquid;
    der(U_vapor) = Ub_vapor;
  end if;

  // Species Balance
  if substanceDynamics == Dynamics.SteadyState then
    zeros(Medium.nXi) = mXib_liquid;
    zeros(Medium.nXi) = mXib_vapor;
  else
    der(mXi_liquid) = mXib_liquid;
    der(mXi_vapor) = mXib_vapor;
  end if;

  // Trace Balance
  if traceDynamics == Dynamics.SteadyState then
    zeros(Medium.nC) = mCb_liquid;
    zeros(Medium.nC) = mCb_vapor;
  else
    der(mC_scaled_liquid)  = mCb_liquid./Medium.C_nominal;
    mC_liquid = mC_scaled_liquid.*Medium.C_nominal;

    der(mC_scaled_vapor)  = mCb_vapor./Medium.C_nominal;
    mC_vapor = mC_scaled_vapor.*Medium.C_nominal;
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialTwoVolume_wlevel;
