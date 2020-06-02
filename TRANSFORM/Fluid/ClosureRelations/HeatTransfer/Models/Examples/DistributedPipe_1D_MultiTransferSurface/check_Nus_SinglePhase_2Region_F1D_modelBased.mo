within TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.Examples.DistributedPipe_1D_MultiTransferSurface;
model check_Nus_SinglePhase_2Region_F1D_modelBased
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.Air.DryAirNasa;
  parameter Integer nHT=2;
  parameter SI.Pressure p[nHT]={1e5,1e5};
  parameter SI.Temperature T[nHT] = {300,500};
  Medium.ThermodynamicState states[nHT];
  SI.Velocity vs[nHT]=fill(v.y, nHT) "Fluid Velocity";
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
  TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region_modelbased
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
    Ts_start=T,
    redeclare model Nus_turb =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.BaseClasses.Nu_SiederTate)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp      v(
    height=99.999,
    duration=1,
    offset=0.001)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=4, x={heatTransfer.alphas[
        1, 1],heatTransfer.alphas[2, 2],heatTransfer.Q_flows[1, 1],heatTransfer.Q_flows[
        2, 2]})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature boundary[nHT,
    nSurfaces]
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
equation
  states[1] = Medium.setState_pT(p[1],T[1]);
  states[2] = Medium.setState_pT(p[2],T[2]);
  connect(heatTransfer.heatPorts, boundary.port)
    annotation (Line(points={{10,0},{20,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_Nus_SinglePhase_2Region_F1D_modelBased;
