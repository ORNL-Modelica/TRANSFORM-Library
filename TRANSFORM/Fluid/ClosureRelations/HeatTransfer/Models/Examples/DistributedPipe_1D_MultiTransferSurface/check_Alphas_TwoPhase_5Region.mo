within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Examples.DistributedPipe_1D_MultiTransferSurface;
model check_Alphas_TwoPhase_5Region
  extends TRANSFORM.Icons.Example;

  package Medium = Modelica.Media.Water.StandardWater;

  parameter Integer nHT=2;

  parameter SI.Pressure p[nHT]={1e5,1e5};
  Medium.ThermodynamicState states[nHT];

  parameter SI.Velocity vs[nHT]=fill(1, nHT) "Fluid Velocity";
  parameter SI.Diameter dimensions[nHT]=fill(0.01, nHT)
    "Characteristic dimension (e.g. hydraulic diameter)";

  parameter SI.Area crossAreas[nHT]={0.25*Modelica.Constants.pi*dimensions[i]^2
      for i in 1:nHT} "Cross sectional flow area";
  parameter SI.Length dlengths[nHT]=fill(1, nHT)
    "Characteristic length of heat transfer segment";
  parameter SI.Height roughnesses[nHT]=fill(2.5e-5, nHT)
    "Average height of surface asperities";

  parameter SI.Area surfaceAreas[nHT,nSurfaces] = {{1/nSurfaces*Modelica.Constants.pi*dimensions[i]*dlengths[i] for j in 1:nSurfaces} for i in 1:nHT}
    "Surface area for heat transfer";
  parameter Integer nSurfaces=2 "Number of heat transfer surfaces";
  parameter SI.Temperature Ts_start[nHT] = fill(298.15,nHT);

  TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Alphas_TwoPhase_5Region
    heatTransfer(
    redeclare package Medium = Medium,
    states=states,
    nHT=nHT,
    vs=vs,
    dimensions=dimensions,
    crossAreas=crossAreas,
    dlengths=dlengths,
    roughnesses=roughnesses,
    nSurfaces=nSurfaces,
    surfaceAreas=surfaceAreas,
    Ts_start=Ts_start)
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
        1, 1],heatTransfer.alphas[2, 2],heatTransfer.Q_flows[1, 1],heatTransfer.Q_flows[
        2, 2]})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature boundary[nHT,
    nSurfaces]
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
equation

  states[1] = Medium.setState_ph(p[1], h.y);
  states[2] = Medium.setState_ph(p[2], h.y + 1e5);

  connect(heatTransfer.heatPorts, boundary.port)
    annotation (Line(points={{10,0},{20,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_Alphas_TwoPhase_5Region;
