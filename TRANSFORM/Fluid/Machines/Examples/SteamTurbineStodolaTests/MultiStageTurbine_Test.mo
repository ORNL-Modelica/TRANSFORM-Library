within TRANSFORM.Fluid.Machines.Examples.SteamTurbineStodolaTests;
model MultiStageTurbine_Test
  "Unit test: a 3-stage MultiStageTurbine reproduces its own design pressure ladder"
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;

  package Medium = Modelica.Media.Water.StandardWater "Working fluid";

  // Design ladder. Deliberately NOT ANO-1 numbers — this exercises the component,
  // not a plant. Round values so a reader can check the arithmetic by hand.
  parameter Integer nStages = 3 "Expansion stages";
  parameter Modelica.Units.SI.Pressure p_ladder[nStages + 1] =
    {6.0e6,2.0e6,5.0e5,1.0e4} "Boundary pressures {inlet, tap_1, tap_2, outlet}";
  parameter Modelica.Units.SI.MassFlowRate m_ladder[nStages] = {100,90,75}
    "Per-stage through-flow; the differences are the extractions";
  parameter Modelica.Units.SI.Temperature T_in = 570.0
    "Inlet temperature. MUST be near saturation — see the Documentation's
     validity-envelope note. Tsat(6 MPa) = 548.7 K, so this is ~21 K superheat,
     representative of a saturated-steam (nuclear) cycle.";
  parameter Real eta = 0.85 "Isentropic efficiency, all stages";

  // Extraction drawn at each tap = the drop in through-flow across it.
  final parameter Modelica.Units.SI.MassFlowRate m_extract[nStages - 1] =
    {m_ladder[i] - m_ladder[i + 1] for i in 1:nStages - 1} "= {10, 15} kg/s";

  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  inner TRANSFORM.Fluid.SystemTF systemTF
    annotation (Placement(transformation(extent={{30,80},{50,100}})));

  TRANSFORM.Fluid.Machines.MultiStageTurbine turbine(
    redeclare package Medium = Medium,
    nStages=nStages,
    p_nominal=p_ladder,
    m_flow_nominal=m_ladder,
    T_in_nominal=T_in,
    eta_is=eta,
    V_tap=5)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT source(
    redeclare package Medium = Medium,
    nPorts=1,
    p=p_ladder[1],
    T=T_in)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT sink(
    redeclare package Medium = Medium,
    nPorts=1,
    p=p_ladder[nStages + 1],
    T=Medium.saturationTemperature(p_ladder[nStages + 1]))
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));

  // Fixed extraction at each tap (negative m_flow = drawn OUT). With the taps
  // loaded this way the tap PRESSURES are the emergent quantity, which is what
  // the test asserts.
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_h extraction[nStages - 1](
    redeclare each package Medium = Medium,
    each nPorts=1,
    m_flow=-m_extract,
    h={Medium.dewEnthalpy(Medium.setSat_p(p_ladder[i])) for i in 2:nStages})
    annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));

  Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(
    w_fixed=3000/60*2*Modelica.Constants.pi)
    annotation (Placement(transformation(extent={{50,-40},{30,-20}})));

  // THE ASSERTION. Each stage's Stodola Kt is derived so that stage passes
  // m_flow_nominal[i] between p_nominal[i] and p_nominal[i+1]. Impose only the
  // two END pressures and the design extractions; the two TAP pressures are then
  // emergent — they depend on both adjacent stages' Kt and on the flow split
  // being mutually consistent. They must land back on the ladder.
  //
  // This is the property mind.md Rule 11 protects and the one ADR-0003 / #74
  // broke twice: sizing a stage to the throttle TOTAL instead of its own flow,
  // or on the liquid side of saturation, leaves the ladder low. A single stage
  // in isolation would make this circular; a chain does not.
  // NORMALISED so the threshold is a fraction, not a Pa value fitted to this one
  // ladder: every entry is (actual / design) and every reference is 1.
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(
    n=2*nStages - 1,
    x=cat(
      1,
      {turbine.vols[i].medium.p/p_ladder[i + 1] for i in 1:nStages - 1},
      {turbine.stages[i].m_flow/m_ladder[i] for i in 1:nStages}),
    x_reference=fill(1.0, 2*nStages - 1),
    errorCalcs=true,
    errorExpected=0.06,
    name="MultiStageTurbine_Test")
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

equation
  connect(source.ports[1], turbine.port_a)
    annotation (Line(points={{-40,0},{-26,0},{-26,4},{-10,4}}, color={0,127,255}));
  connect(turbine.port_b, sink.ports[1])
    annotation (Line(points={{10,4},{26,4},{26,0},{40,0}}, color={0,127,255}));
  connect(turbine.shaft_b, constantSpeed.flange)
    annotation (Line(points={{10,0},{20,0},{20,-30},{30,-30}}, color={0,0,0}));
  for i in 1:nStages - 1 loop
    connect(extraction[i].ports[1], turbine.drain_extract[i]);
  end for;

  annotation (
    experiment(StopTime=200, Tolerance=1e-6, __Dymola_Algorithm="Dassl"),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Unit test for <code>TRANSFORM.Fluid.Machines.MultiStageTurbine</code>.</p>

<h4>What it asserts</h4>
<p>A 3-stage machine is given a design ladder &mdash; boundary pressures
{6.0, 2.0, 0.5, 0.01}&nbsp;MPa and per-stage through-flows {100, 90, 75}&nbsp;kg/s,
so the two extractions are 10 and 15&nbsp;kg/s. Only the two <em>end</em> pressures
are imposed, together with the design extraction at each tap. The two <em>tap</em>
pressures and all three stage flows are therefore emergent: each depends on the
Stodola coefficients of both adjacent stages and on the flow split being mutually
consistent. All five are asserted as (actual/design), reference 1.</p>

<p>Measured at the time of writing (Dassl, tol 1e-6, t = 200&nbsp;s):
tap&nbsp;1 &minus;3.6&nbsp;%, tap&nbsp;2 &minus;6.9&nbsp;%, stage flows +0.44 / +0.49 /
+0.58&nbsp;%; RMS 0.045. <code>errorExpected = 0.06</code> sits just above that.
It is a regression gate with real teeth rather than a tight correctness proof: the
two failure modes below throw it out by <em>orders</em> of magnitude, not
percent.</p>

<h4>Why this property</h4>
<p>It is the one the component exists to protect, and it has been broken twice in
practice: sizing a stage's <code>Kt</code> to the <em>total</em> throughput rather
than the flow that stage actually carries, and evaluating the nominal density on
the <em>liquid</em> side of saturation (<code>Tsat(p)&minus;5</code>, where IF97
returns ~950&nbsp;kg/m&sup3; and <code>Kt</code> comes out ~30&times; too small).
Either leaves the downstream pressure ladder low and looks like a deep structural
problem rather than one calibration line. Asserting a <em>chain</em> rather than a
single stage is what makes the check non-circular &mdash; a lone stage handed its
own design boundaries would reproduce them trivially.</p>

<h4>VALIDITY ENVELOPE &mdash; near-saturated inlets only</h4>
<p><strong>This component's <code>Kt</code> derivation assumes the expansion stays
near saturation, and it is not documented on the component itself.</strong> Stage 1
is sized at the user's <code>T_in_nominal</code>, but stages 2..n are sized at a
hardcoded <code>Tsat(p)+5</code> &mdash; so if the real expansion lands far from
saturation, those stages are sized on the wrong density and the ladder walks.</p>
<p>Measured while building this test. With the inlet at 773&nbsp;K / 6&nbsp;MPa
(~224&nbsp;K superheat) instead of the 570&nbsp;K used here, stage 2 actually sees
642&nbsp;K &mdash; still 151&nbsp;K superheated &mdash; against a nominal
490.5&nbsp;K. Density 8.08 vs 9.87&nbsp;kg/m&sup3;, 18&nbsp;% low; Stodola goes as
&radic;&rho;, so the stage passes ~90&nbsp;% of design flow, backs up, and tap 1
lands at 2.30&nbsp;MPa &mdash; <strong>+15.2&nbsp;%</strong> off the ladder.</p>
<p>So: fine for saturated-steam (nuclear) cycles, which is what it was written for.
A high-superheat (fossil) user needs <code>T_nominal</code> to be settable per
stage rather than assumed. Until that exists, keep <code>T_in</code> near
saturation in this test &mdash; a failure here means either a real regression or
someone widened the inlet superheat.</p>
</html>"));
end MultiStageTurbine_Test;
