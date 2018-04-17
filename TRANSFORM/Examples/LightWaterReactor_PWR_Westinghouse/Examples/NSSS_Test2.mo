within TRANSFORM.Examples.LightWaterReactor_PWR_Westinghouse.Examples;
model NSSS_Test2
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;

  TRANSFORM.Examples.LightWaterReactor_PWR_Westinghouse.NSSS2 PHS
    annotation (Placement(transformation(extent={{-40,-42},{40,38}})));

  Modelica.Fluid.Sources.Boundary_ph sink(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1,
    use_p_in=true,
    p(displayUnit="MPa") = PHS.data.p_shellSide,
    h=PHS.data.h_vsat)
    annotation (Placement(transformation(extent={{69,9},{59,19}})));
  Modelica.Fluid.Sources.MassFlowSource_T source(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1,
    use_m_flow_in=false,
    m_flow=PHS.data.m_flow_shellSide_total,
    T=PHS.data.sat.Tsat - 20)
    annotation (Placement(transformation(extent={{69,-24},{57,-12}})));
  Modelica.Blocks.Sources.Sine sine(
    startTime=100,
    freqHz=1/1000,
    amplitude=20e5,
    offset=PHS.port_b_nominal.p)
    annotation (Placement(transformation(extent={{100,6},{80,26}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={PHS.pressurizer.drum2Phase.p,
        PHS.coreSubchannel.reactorKinetics.Q_total})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(sink.ports[1], PHS.port_b)
    annotation (Line(points={{59,14},{40,14}}, color={0,127,255}));
  connect(source.ports[1], PHS.port_a) annotation (Line(points={{57,-18},{48.5,
          -18},{40,-18}}, color={0,127,255}));
  connect(sine.y, sink.p_in) annotation (Line(points={{79,16},{74,16},{74,18},{
          70,18}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(
      StopTime=100,
      __Dymola_NumberOfIntervals=100,
      __Dymola_Algorithm="Esdirk45a"),
    __Dymola_experimentSetupOutput);
end NSSS_Test2;
