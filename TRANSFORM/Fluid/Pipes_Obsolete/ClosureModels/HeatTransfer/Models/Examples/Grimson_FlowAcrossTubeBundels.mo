within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.Examples;
model Grimson_FlowAcrossTubeBundels
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.Water.StandardWater;
  parameter SI.Pressure p = 1e5 "Absolute pressure";
  parameter SI.SpecificEnthalpy h = 1e5 "Specific enthalpy";
  parameter SI.Temperature T = Medium.temperature_phX(p,h,Medium.X_default) "Temperature";
  parameter SI.MassFlowRate[heatTransfer.geometry.nNodes] m_flows = 1*ones(heatTransfer.geometry.nNodes) "Mass flow rate";
  parameter Medium.ThermodynamicState[heatTransfer.geometry.nNodes] states= fill(Medium.setState_phX(p,h,Medium.X_default),heatTransfer.geometry.nNodes) "Thermodynamic states";
  TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.SinglePhase.Grimson_FlowAcrossTubeBundels
    heatTransfer(
    redeclare package Medium = Medium,
    states=states,
    m_flows=m_flows,
    redeclare model Geometry =
        TRANSFORM.Fluid.Volumes.ClosureModels.Geometry.Models.Volume.StraightPipe
        (dimension=1),
    D=0.1,
    S_T=1.25*0.1,
    S_L=1.25*0.1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature[heatTransfer.geometry.nNodes](each T=T)
    annotation (Placement(transformation(extent={{60,-11},{40,11}})));
equation
  connect(heatTransfer.heatPorts, fixedTemperature.port)
    annotation (Line(points={{10,0},{40,0}},        color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Grimson_FlowAcrossTubeBundels;
