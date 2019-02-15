within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Models.Examples;
model Constant_alphas_Test
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.Water.StandardWater;
  parameter SI.Pressure p = 1e5 "Absolute pressure";
  parameter SI.SpecificEnthalpy h = 1e5 "Specific enthalpy";
  parameter SI.Temperature T = Medium.temperature_phX(p,h,Medium.X_default) "Temperature";
  parameter Real nParallel = 2 "Number of parallel heat transfer segments";
  parameter Integer nHT = 2 "Number of serial heat transfer segments";
  parameter SI.Length[nHT] lengths = 1.0*ones(nHT) "Length of heat transfer segments";
  parameter SI.Length[nHT] dimensions = 1.0*ones(nHT) "Hydraulic diameter";
  parameter SI.MassFlowRate[nHT] m_flows = 1*ones(nHT) "Mass flow rate";
  parameter Medium.ThermodynamicState[nHT] states= fill(Medium.setState_phX(p,h,Medium.X_default),nHT) "Thermodynamic states";
  Constant_alphas
        heatTransfer(
    redeclare package Medium = Medium,
    nParallel=nParallel,
    nHT=nHT,
    states=states,
    m_flows=m_flows,
    lengths=lengths,
    dimensions=dimensions,
    alpha0=10e3)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature[nHT](each T=T)
    annotation (Placement(transformation(extent={{60,-11},{40,11}})));
equation
  connect(heatTransfer.heatPorts, fixedTemperature.port)
    annotation (Line(points={{10,0},{40,0}},        color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Constant_alphas_Test;
