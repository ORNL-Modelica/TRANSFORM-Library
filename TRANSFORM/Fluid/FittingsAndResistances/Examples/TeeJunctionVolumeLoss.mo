within TRANSFORM.Fluid.FittingsAndResistances.Examples;
model TeeJunctionVolumeLoss
  "Dividing-flow tee with an angle-dependent 90 deg branch take-off to a smaller pipe"
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  inner Modelica.Fluid.System system(p_ambient(displayUnit="Pa") = 100000,
      m_flow_small=1e-4)
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  inner TRANSFORM.Fluid.SystemTF systemTF
    annotation (Placement(transformation(extent={{86,-100},{106,-80}})));
  TRANSFORM.Fluid.FittingsAndResistances.TeeJunctionVolumeLoss tee(
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    V=1e-4,
    d_run=0.05,
    d_branch=0.025,
    angle=Modelica.Constants.pi/2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "90 deg tee, 0.05 m run, 0.025 m branch"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Fluid.Sources.MassFlowSource_T IN1(
    m_flow=0.05,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa)
    "Constant 0.05 kg/s combined inlet"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance R_run(
    redeclare package Medium = Modelica.Media.Air.DryAirNasa, R=2e5)
    "Downstream run resistance (sets a well-posed network / avoids pinning)"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Fluid.Sources.FixedBoundary OUT2(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa) "Run outlet"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,0})));
  Modelica.Fluid.Sources.MassFlowSource_T BRANCH(
    use_m_flow_in=true,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa)
    "Imposes the branch draw-off (sweeps the flow ratio)" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,50})));
  Modelica.Blocks.Sources.Ramp branch_draw(
    height=-0.04,
    duration=0.8,
    offset=0,
    startTime=0.1)
    "Branch extraction 0 -> 0.04 kg/s, so the branch flow ratio Qr sweeps 0 -> 0.8"
    annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
equation
  connect(IN1.ports[1], tee.port_1)
    annotation (Line(points={{-50,0},{-10,0}}, color={0,127,255}));
  connect(tee.port_2, R_run.port_a)
    annotation (Line(points={{10,0},{23,0}}, color={0,127,255}));
  connect(R_run.port_b, OUT2.ports[1])
    annotation (Line(points={{37,0},{60,0}}, color={0,127,255}));
  connect(BRANCH.ports[1], tee.port_3)
    annotation (Line(points={{0,40},{0,10}}, color={0,127,255}));
  connect(branch_draw.y, BRANCH.m_flow_in) annotation (Line(points={{-49,50},{-20,
          50},{-20,58},{-8,58}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1, Interval=0.001),
    Documentation(info="<html>
<p>Unit test for
<a href=\"modelica://TRANSFORM.Fluid.FittingsAndResistances.TeeJunctionVolumeLoss\">TeeJunctionVolumeLoss</a>.
A constant 0.05&nbsp;kg/s of air enters the run inlet (<code>port_1</code>) and divides between the straight run
(<code>port_2</code> &rarr; a downstream resistance &rarr; ambient) and a 90&deg; branch (<code>port_3</code>,
0.025&nbsp;m) whose draw-off is ramped so the branch flow ratio <code>Qr</code> sweeps from 0 to 0.8. This exercises the
angle- and flow-ratio-dependent Crane branch and run loss coefficients (<code>tee.K_branch</code>,
<code>tee.K_run</code>) over their range.</p>
<p>The branch split is imposed (rather than left to equal-pressure outlets, which would over-constrain the split with
the tee as the only resistance), and a downstream resistance is placed on the run leg so the volume pressure is not
pinned directly to an ideal boundary &ndash; representative of normal network usage.</p>
</html>"));
end TeeJunctionVolumeLoss;
