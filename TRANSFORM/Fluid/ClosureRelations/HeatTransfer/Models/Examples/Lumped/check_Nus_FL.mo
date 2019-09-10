within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Examples.Lumped;
model check_Nus_FL
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.Water.StandardWater;
  parameter Integer nSurfaces=2 "Number of heat transfer surfaces";
  parameter SI.Pressure p=1e5;
  Medium.ThermodynamicState state;
  parameter SI.Velocity v=1 "Fluid Velocity";
  parameter SI.Diameter dimension=0.01
    "Characteristic dimension (e.g. hydraulic diameter)";
  parameter SI.Area crossArea=0.25*Modelica.Constants.pi*dimension^2 "Cross sectional flow area";
  parameter SI.Length dlength=1
    "Characteristic length of heat transfer segment";
  parameter SI.Height roughness=2.5e-5
    "Average height of surface asperities";
  parameter SI.Area surfaceAreas[nSurfaces] = fill(1/nSurfaces*Modelica.Constants.pi*dimension*dlength,nSurfaces)
    "Surface area for heat transfer";
  parameter SI.Temperature T_start = 298.15;
  TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Lumped.Nus heatTransfer(
    redeclare package Medium = Medium,
    state=state,
    v=v,
    dimension=dimension,
    crossArea=crossArea,
    nSurfaces=nSurfaces,
    surfaceAreas=surfaceAreas)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Trapezoid h(
    rising=1,
    width=0,
    falling=1,
    period=2,
    nperiod=1,
    amplitude=3e6,
    offset=1e5)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=4, x={heatTransfer.alphas[
        1],heatTransfer.alphas[2],heatTransfer.Q_flows[1],heatTransfer.Q_flows[
        2]}) annotation (Placement(transformation(extent={{80,80},{100,100}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature
                                                       boundary[nSurfaces]
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
equation
  state = Medium.setState_ph(p, h.y);
  connect(heatTransfer.heatPorts, boundary.port)
    annotation (Line(points={{10,0},{20,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_Nus_FL;
