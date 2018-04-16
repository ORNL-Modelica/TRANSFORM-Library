within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models;
partial model PartialHeatTransfer_setT
  "Base model required to allow for models that set the temperature state rather than Q_flows"

  replaceable package Medium =
    Modelica.Media.Air.MoistAir
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation(choicesAllMatching=true);
  parameter SI.Acceleration g = Modelica.Constants.g_n "Gravitational acceleration";

  input Medium.ThermodynamicState[nHT] states "Thermodynamic state of fluid"
   annotation(Dialog(tab="Internal Interface",group="Inputs"));
  input SI.MassFlowRate[nHT] m_flows "Mass flow rate"
   annotation(Dialog(tab="Internal Interface",group="Inputs"));

  // Geometry
  replaceable model Geometry =
      TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe
    "Geometry" annotation (choicesAllMatching=true);

  Geometry geometry
    annotation (Placement(transformation(extent={{-76,84},{-64,96}})));

  parameter Real nParallel "Number of parallel heat transfer segments"
    annotation(Dialog(tab="Internal Interface",group="Geometry"));
  parameter Integer nHT = geometry.nNodes "Number of serial heat transfer segments"
    annotation(Dialog(tab="Internal Interface",group="Geometry"));

  input SI.Length[nHT] lengths = geometry.dlengths "Characteristic length of heat transfer segment"
   annotation(Dialog(tab="Internal Interface",group="Inputs"));

  final parameter Boolean use_Dimensions=geometry.use_Dimensions
    "= true to specify characteristic dimension"
   annotation(Dialog(tab="Internal Interface",group="Inputs"), Evaluate=true);
  input SI.Diameter[nHT] dimensions=geometry.dimensions  "Characteristic dimension (e.g. hydraulic diameter)"
   annotation(Dialog(tab="Internal Interface",group="Inputs", enable=use_Dimensions));
  input SI.Area[nHT] crossAreas = geometry.crossAreas "Cross sectional area"
   annotation(Dialog(tab="Internal Interface",group="Inputs", enable=not use_Dimensions));
  input SI.Length[nHT] perimeters=geometry.perimeters "Wetted perimeter"
   annotation(Dialog(tab="Internal Interface",group="Inputs"), enable=not use_Dimensions);
  input SI.Area[nHT] surfaceAreas=geometry.surfaceAreas_23 "Heat transfer area"
   annotation(Dialog(tab="Internal Interface",group="Inputs"));

  parameter SI.MassFlowRate m_flow_nominal = 1 "Mass flow rate"
   annotation(Dialog(tab="Internal Interface",group="Nominal Conditions:"));
  parameter SI.Pressure p_nominal = Medium.p_default "Pressure"
   annotation(Dialog(tab="Internal Interface",group="Nominal Conditions:"));
  parameter Boolean use_T_nominal=true "= true then use temperature else enthalpy"
   annotation(Dialog(tab="Internal Interface",group="Nominal Conditions:"),Evaluate=true);
  parameter SI.Temperature T_nominal = if use_T_nominal then Medium.T_default else Medium.temperature_phX(p_nominal,h_nominal,X_nominal) "Temperature"
   annotation(Dialog(tab="Internal Interface",group="Nominal Conditions:",enable=use_T_nominal));
  parameter SI.SpecificEnthalpy h_nominal = if use_T_nominal then Medium.specificEnthalpy_pTX(p_nominal,T_nominal,X_nominal) else Medium.h_default "Specific Enthalpy"
   annotation(Dialog(tab="Internal Interface",group="Nominal Conditions:",enable= not use_T_nominal));
  parameter Medium.MassFraction X_nominal[Medium.nX]=Medium.X_default "Mass fractions m_i/m"
    annotation (Dialog(tab="Internal Interface",group="Nominal Conditions:", enable=Medium.nXi > 0));

  SI.Temperature[nHT] Ts_fluid = Medium.temperature(states) "Fluid temperature";
  SI.Temperature[nHT] Ts_wall = heatPorts.T "Wall temperature";
  SI.Temperature[nHT] Ts_film = 0.5*(Ts_wall + Ts_fluid) "Film temperature";
  Medium.ThermodynamicState[nHT] states_film = Medium.setState_pTX(states.p,Ts_film,Medium.X_default) "Film state";

  SI.CoefficientOfHeatTransfer[nHT] alphas "Coefficient of heat transfer";
  SI.HeatFlowRate[nHT] Q_flows = heatPorts.Q_flow
                              "Heat flow rate";

  Media.BaseProperties1Phase[nHT] mediums1(
    redeclare package Medium = Medium,
    state = states) "Bulk fluid properties"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Media.BaseProperties1Phase[nHT] mediums1_film(
    redeclare package Medium = Medium,
    state = states_film) "Film fluid properties"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

  HeatAndMassTransfer.Interfaces.HeatPort_Flow[nHT] heatPorts annotation (
      Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(
          extent={{90,-10},{110,10}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Bitmap(extent={{-124,-100},{124,100}}, fileName="modelica://TRANSFORM/Resources/Images/Icons/HeatTransfer_alphas.jpg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialHeatTransfer_setT;
