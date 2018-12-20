within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Models.Examples;
model check_Nus
  extends TRANSFORM.Icons.Example;

  package Medium = Modelica.Media.Water.StandardWater;

  parameter Integer nHT=2;

  parameter SI.Pressure p[nHT]={1e5,1e5};
  Medium.ThermodynamicState states[nHT];

  SI.Temperature Ts_fluid[nHT]=Medium.temperature(states);
  SI.Temperature Ts_wall[nHT]=Ts_fluid + fill(10, nHT);

  parameter SI.Velocity vs[nHT]=fill(1, nHT) "Fluid Velocity";
  parameter SI.Diameter dimensions[nHT]=fill(0.01, nHT)
    "Characteristic dimension (e.g. hydraulic diameter)";

  parameter SI.Area crossAreas[nHT]={0.25*Modelica.Constants.pi*dimensions[i]^2
      for i in 1:nHT} "Cross sectional flow area";
  parameter SI.Length dlengths[nHT]=fill(1, nHT)
    "Characteristic length of heat transfer segment";
  parameter SI.Height roughnesses[nHT]=fill(2.5e-5, nHT)
    "Average height of surface asperities";

  Nus heatTransfer(
    redeclare package Medium = Medium,
    states=states,
    Ts_wall=Ts_wall,
    Ts_fluid=Ts_fluid,
    nHT=nHT,
    vs=vs,
    dimensions=dimensions,
    crossAreas=crossAreas,
    dlengths=dlengths,
    roughnesses=roughnesses)
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
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x=heatTransfer.alphas)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation

  states[1] = Medium.setState_ph(p[1], h.y);
  states[2] = Medium.setState_ph(p[2], h.y + 1e5);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_Nus;
