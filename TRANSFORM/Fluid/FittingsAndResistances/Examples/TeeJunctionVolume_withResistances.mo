within TRANSFORM.Fluid.FittingsAndResistances.Examples;
model TeeJunctionVolume_withResistances
  "Tee with different-sized legs: mixed old-style and new-style branch resistances"
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  inner Modelica.Fluid.System system(p_ambient(displayUnit="Pa") = 100000,
      m_flow_small=1e-4)
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  TRANSFORM.Fluid.FittingsAndResistances.TeeJunctionVolume_withResistances tee(
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    V=1e-4,
    resistance_1(dp0=10),
    redeclare TRANSFORM.Fluid.FittingsAndResistances.Elbow resistance_2(
      dimension=0.05,
      radius=0.075,
      angle=Modelica.Constants.pi/2),
    redeclare TRANSFORM.Fluid.FittingsAndResistances.SmoothAdaptor resistance_3(
      dimensions_ab={0.05,0.02},
      angle=0.2617993877991494)) "resistance_1: default (old-style) PressureLoss;
    resistance_2: new-style Elbow on the through-run; resistance_3: new-style
    SmoothAdaptor transitioning the 0.05 m junction to a 0.02 m branch pipe"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Fluid.Sources.MassFlowSource_T IN1(
    T=system.T_ambient,
    nPorts=1,
    use_m_flow_in=true,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa) annotation (
      Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Fluid.Sources.FixedBoundary OUT2(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,0})));
  Modelica.Fluid.Sources.FixedBoundary OUT3(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,50})));
  Modelica.Blocks.Sources.Ramp input_mflow(
    height=0.02,
    duration=0.5,
    offset=0,
    startTime=0) "Inlet flow rate ramps up, splitting between the two outlets"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
equation
  connect(IN1.ports[1], tee.port_1)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(tee.port_2, OUT2.ports[1])
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  connect(tee.port_3, OUT3.ports[1])
    annotation (Line(points={{0,10},{0,40}}, color={0,127,255}));
  connect(input_mflow.y, IN1.m_flow_in) annotation (Line(points={{-79,0},{-72,0},
          {-72,8},{-60,8}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1, Interval=0.001),
    Documentation(info="<html>
<p>Unit test for
<a href=\"modelica://TRANSFORM.Fluid.FittingsAndResistances.TeeJunctionVolume_withResistances\">TeeJunctionVolume_withResistances</a>
exercising its widened resistance interface. The three branch resistances mix both base-class families in a single tee:</p>
<ul>
<li><code>resistance_1</code> &ndash; the default old-style
<a href=\"modelica://TRANSFORM.Fluid.FittingsAndResistances.PressureLoss\">PressureLoss</a>
(extends <code>PartialResistance</code>);</li>
<li><code>resistance_2</code> &ndash; a new-style
<a href=\"modelica://TRANSFORM.Fluid.FittingsAndResistances.Elbow\">Elbow</a>
(extends <code>PartialResistancenew</code>) on the through-run;</li>
<li><code>resistance_3</code> &ndash; a new-style
<a href=\"modelica://TRANSFORM.Fluid.FittingsAndResistances.SmoothAdaptor\">SmoothAdaptor</a>
transitioning the 0.05 m junction down to a 0.02 m branch pipe &mdash; i.e. the &quot;small pipe coming off the tee&quot;.</li>
</ul>
<p>The inlet mass flow is ramped and splits between the two outlets according to the per-leg resistances, confirming that
the tee now accepts resistances built on <i>either</i> base class through the shared
<a href=\"modelica://TRANSFORM.Fluid.FittingsAndResistances.BaseClasses.PartialResistanceInterface\">PartialResistanceInterface</a>
constraint.</p>
</html>"));
end TeeJunctionVolume_withResistances;
