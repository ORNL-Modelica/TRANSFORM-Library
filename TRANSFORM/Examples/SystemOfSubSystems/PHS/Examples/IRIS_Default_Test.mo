within TRANSFORM.Examples.SystemOfSubSystems.PHS.Examples;
model IRIS_Default_Test
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  IRIS PHS annotation (Placement(transformation(extent={{-40,-42},{40,38}})));
  Modelica.Fluid.Sources.Boundary_ph sink(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1,
    use_p_in=true,
    p(displayUnit="MPa") = 5.8e6,
    h=source.Medium.specificEnthalpy_pT(5.8e6, 591))
    annotation (Placement(transformation(extent={{69,9},{59,19}})));
  Modelica.Fluid.Sources.MassFlowSource_h source(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1,
    use_m_flow_in=false,
    m_flow=502.8,
    h=source.Medium.specificEnthalpy_pT(6.19e6, 497))
    annotation (Placement(transformation(extent={{69,-24},{57,-12}})));
  Modelica.Blocks.Sources.Sine sine1(
    f=1/1000,
    amplitude=20e5,
    offset=PHS.port_b_nominal.p,
    startTime=100)
    annotation (Placement(transformation(extent={{100,8},{80,28}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={PHS.pressurizer.drum2Phase.p,
        PHS.coreSubchannel.kinetics.Q_total})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(PHS.port_b, sink.ports[1])
    annotation (Line(points={{40,14},{59,14}}, color={0,127,255}));
  connect(PHS.port_a, source.ports[1])
    annotation (Line(points={{40,-18},{57,-18}}, color={0,127,255}));
  connect(sink.p_in, sine1.y)
    annotation (Line(points={{70,18},{79,18}},         color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(
      StopTime=100,
      __Dymola_NumberOfIntervals=100,
      __Dymola_Algorithm="Esdirk45a"),
    __Dymola_experimentSetupOutput);
end IRIS_Default_Test;
