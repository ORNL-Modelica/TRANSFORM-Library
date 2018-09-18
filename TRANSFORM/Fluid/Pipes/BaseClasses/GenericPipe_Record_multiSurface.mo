within TRANSFORM.Fluid.Pipes.BaseClasses;
record GenericPipe_Record_multiSurface
  import TRANSFORM;

  import Modelica.Fluid.Types.Dynamics;
  import TRANSFORM.Math.linspace_1D;
  import TRANSFORM.Math.linspaceRepeat_1D;
  import TRANSFORM.Fluid.Types.LumpedLocation;

  parameter Real nParallel=1 "Number of parallel components";

  replaceable package Medium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialMedium "Medium properties"
    annotation (choicesAllMatching=true);

  parameter Integer nV(min=1) = 1 "Number of discrete volumes";

  // Advanced
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

  // Initialization
  parameter SI.AbsolutePressure[nV] ps_start=linspace_1D(
        p_a_start,
        p_b_start,nV) "Pressure"
    annotation (Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));
  parameter Boolean use_Ts_start=true "Use T_start if true, otherwise h_start"
    annotation (Evaluate=true, Dialog(tab="Initialization", group="Start Value: Temperature"));
  parameter SI.Temperature Ts_start[nV]=linspace_1D(
        T_a_start,
        T_b_start,nV) "Temperature" annotation (
      Evaluate=true, Dialog(
      tab="Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start));
  parameter SI.SpecificEnthalpy[nV] hs_start=if not use_Ts_start then linspace_1D(
        h_a_start,
        h_b_start,nV)
             else {Medium.specificEnthalpy_pTX(
        ps_start[i],
        Ts_start[i],
        Xs_start[i, 1:Medium.nX]) for i in 1:nV} "Specific enthalpy" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start));
  parameter SI.MassFraction Xs_start[nV,Medium.nX]=linspaceRepeat_1D(
        X_a_start,
        X_b_start,nV)
    "Mass fraction" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Species Mass Fraction",
      enable=Medium.nXi > 0));
  parameter SIadd.ExtraProperty Cs_start[nV,Medium.nC]=linspaceRepeat_1D(
        C_a_start,
        C_b_start,nV) "Mass-Specific value" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Trace Substances",
      enable=Medium.nC > 0));

  parameter SI.AbsolutePressure p_a_start=Medium.p_default "Pressure at port a"
    annotation (Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_b_start=p_a_start + (if m_flow_a_start > 0 then -1e3 elseif m_flow_a_start < 0 then -1e3 else 0) "Pressure at port b"
    annotation (Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));

  parameter SI.Temperature T_a_start=Medium.T_default "Temperature at port a" annotation (
      Dialog(
      tab="Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start));
  parameter SI.Temperature T_b_start=T_a_start "Temperature at port b" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Temperature",
      enable=use_Ts_start));

  parameter SI.SpecificEnthalpy h_a_start=Medium.specificEnthalpy_pTX(
      p_a_start,
      T_a_start,
      X_a_start) "Specific enthalpy at port a" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start));
  parameter SI.SpecificEnthalpy h_b_start=Medium.specificEnthalpy_pTX(
      p_b_start,
      T_b_start,
      X_b_start) "Specific enthalpy at port b" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Specific Enthalpy",
      enable=not use_Ts_start));

  parameter SI.MassFraction X_a_start[Medium.nX]=Medium.X_default
    "Mass fraction at port a"
    annotation (Dialog(tab="Initialization", group="Start Value: Species Mass Fraction"));
  parameter SI.MassFraction X_b_start[Medium.nX]=X_a_start
    "Mass fraction at port b"
    annotation (Dialog(tab="Initialization", group="Start Value: Species Mass Fraction"));

  parameter SIadd.ExtraProperty C_a_start[Medium.nC]=fill(0, Medium.nC)
    "Mass-Specific value at port a"
    annotation (Dialog(tab="Initialization", group="Start Value: Trace Substances"));
  parameter SIadd.ExtraProperty C_b_start[Medium.nC]=C_a_start
    "Mass-Specific value at port b"
    annotation (Dialog(tab="Initialization", group="Start Value: Trace Substances"));

  parameter SI.MassFlowRate m_flow_a_start=0 "Mass flow rate at port_a"
    annotation (Dialog(tab="Initialization", group="Start Value: Mass Flow Rate"));
  parameter SI.MassFlowRate m_flow_b_start=-m_flow_a_start "Mass flow rate at port_b"
    annotation (Dialog(tab="Initialization", group="Start Value: Mass Flow Rate"));
  parameter SI.MassFlowRate[nV + 1] m_flows_start=linspace(
      m_flow_a_start,
      -m_flow_b_start,
      nV + 1) "Mass flow rates" annotation (Evaluate=true, Dialog(tab="Initialization", group=
         "Start Value: Mass Flow Rate"));

  // Pressure Loss Model
  replaceable model FlowModel =
      TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.SinglePhase_Developed_2Region_NumStable
                                                     constrainedby
    TRANSFORM.Fluid.ClosureRelations.PressureLoss.Models.DistributedPipe_1D.PartialDistributedStaggeredFlow
                                                "Pressure loss models (i.e., momentum, wall friction)" annotation (Dialog(
        group="Pressure Loss"), choicesAllMatching=true);

  // Heat Transfer Model
  parameter Boolean use_HeatTransfer=false "= true to use the HeatTransfer model"
    annotation (Dialog(group="Heat Transfer"));

  replaceable model HeatTransfer =
      TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Ideal
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.PartialHeatTransfer_setT
    "Coefficient of heat transfer" annotation (Dialog(group="Heat Transfer", enable=
          use_HeatTransfer), choicesAllMatching=true);

  // Internal Heat Generation Model
  replaceable model InternalHeatGen =
      TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
                                                     constrainedby
    TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.PartialInternalHeatGeneration
                                                "Internal heat generation" annotation (Dialog(
        group="Heat Transfer"), choicesAllMatching=true);

  // Assumptions
  parameter Boolean exposeState_a=true "=true, p is calculated at port_a else m_flow"
    annotation (Dialog(group="Model Structure", tab="Advanced"));
  parameter Boolean exposeState_b=false "=true, p is calculated at port_b else m_flow"
    annotation (Dialog(group="Model Structure", tab="Advanced"));

  // Initialization
  parameter Modelica.Fluid.Types.Dynamics momentumDynamics=Dynamics.SteadyState
    "Formulation of momentum balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));

  // Advanced
  input SI.Acceleration g_n=Modelica.Constants.g_n "Gravitational acceleration"
    annotation (Dialog(tab="Advanced", group="Inputs"));

  parameter Boolean useInnerPortProperties=false
    "=true to take port properties for flow models from internal control volumes"
    annotation (Dialog(tab="Advanced",group="Parameters"), Evaluate=true);
  parameter Boolean useLumpedPressure=false "=true to lump pressure states together"
    annotation (Dialog(tab="Advanced",group="Parameters"), Evaluate=true);
  parameter LumpedLocation lumpPressureAt=LumpedLocation.port_a
    "Location of pressure for flow calculations"
    annotation (Dialog(tab="Advanced",group="Parameters",enable=useLumpedPressure), Evaluate=true);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GenericPipe_Record_multiSurface;
