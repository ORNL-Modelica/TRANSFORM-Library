within TRANSFORM.Fluid.Machines.Examples.SteamTurbineStodolaTests;
model MultiStageTurbine_Superheat_Test
  "Unit test: an explicit per-stage T_nominal holds the ladder on a HIGH-SUPERHEAT expansion"
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;

  package Medium = Modelica.Media.Water.StandardWater "Working fluid";

  // Same ladder as MultiStageTurbine_Test, but a fossil-style superheated inlet:
  // Tsat(6 MPa) = 548.7 K, so 773.15 K is ~224 K of superheat. This is exactly
  // the case the DEFAULT Tsat+5 sizing gets wrong.
  parameter Integer nStages = 3 "Expansion stages";
  parameter Modelica.Units.SI.Pressure p_ladder[nStages + 1] =
    {6.0e6,2.0e6,5.0e5,1.0e4} "Boundary pressures {inlet, tap_1, tap_2, outlet}";
  parameter Modelica.Units.SI.MassFlowRate m_ladder[nStages] = {100,90,75}
    "Per-stage through-flow; the differences are the extractions";
  parameter Modelica.Units.SI.Temperature T_in = 773.15
    "Inlet temperature — ~224 K superheat at 6 MPa";
  parameter Real eta = 0.85 "Isentropic efficiency, all stages";

  // THE POINT OF THIS TEST. Per-stage nominal inlet temperatures, set explicitly
  // instead of taking the near-saturation default. Obtained the way the component
  // Documentation prescribes: run once with the default, read the settled stage
  // inlet temperatures (stage i+1's inlet is vols[i].medium.T), feed them back.
  // Iterated to a fixed point: pass 1 (default sizing) gave {641.9, 458.5},
  // then 637.0/451.0 -> 623.7/478.3 -> 624.7/474.8. At that point T_nominal and
  // the temperatures the stages actually see agree to <0.1 % (624.6 / 475.2).
  parameter Modelica.Units.SI.Temperature T_stage[nStages] = {773.15,624.7,474.8}
    "Measured stage inlet temperatures — NOT Tsat+5";

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
    T_nominal=T_stage,
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

  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_h extraction[nStages - 1](
    redeclare each package Medium = Medium,
    each nPorts=1,
    m_flow=-m_extract,
    h={Medium.specificEnthalpy_pT(p_ladder[i + 1], T_stage[i + 1])
       for i in 1:nStages - 1})
    annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));

  Modelica.Mechanics.Rotational.Sources.ConstantSpeed constantSpeed(
    w_fixed=3000/60*2*Modelica.Constants.pi)
    annotation (Placement(transformation(extent={{50,-40},{30,-20}})));

  // Same assertion as MultiStageTurbine_Test — both tap pressures and all three
  // stage flows as (actual/design), reference 1 — so the two tests are directly
  // comparable and the ONLY difference is T_nominal.
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(
    n=2*nStages - 1,
    x=cat(
      1,
      {turbine.vols[i].medium.p/p_ladder[i + 1] for i in 1:nStages - 1},
      {turbine.stages[i].m_flow/m_ladder[i] for i in 1:nStages}),
    x_reference=fill(1.0, 2*nStages - 1),
    errorCalcs=true,
    errorExpected=0.005,
    name="MultiStageTurbine_Superheat_Test")
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
<p>Companion to
<code>MultiStageTurbine_Test</code>: the same 3-stage machine and the same design
ladder, but a <strong>high-superheat</strong> inlet (773.15&nbsp;K at 6&nbsp;MPa,
~224&nbsp;K above saturation) and an explicit per-stage
<code>T_nominal</code>.</p>

<h4>What it demonstrates</h4>
<p><code>MultiStageTurbine</code>'s default Stodola sizing evaluates stages 2..n at
<code>Tsat(p) + dT_superheat_nominal</code>, which assumes the expansion stays near
saturation. On this inlet it does not: stage 2 actually settles around
640&nbsp;K against a 490.5&nbsp;K default nominal, its density is ~18&nbsp;% low,
and since <code>Kt</code> goes as 1/&radic;&rho; the stage passes only ~90&nbsp;%
of design flow, backs up, and puts tap 1 <strong>+15.2&nbsp;%</strong> off the
ladder. Setting <code>T_nominal</code> to the temperatures the stages actually see
recovers it.</p>

<p>Together the two tests pin the envelope from both sides: the default sizing is
correct for near-saturated (nuclear) expansions and must be overridden for
superheated (fossil) ones. Neither passing alone would establish that.</p>

<h4>How T_nominal was obtained</h4>
<p>By iterating to a fixed point, because the stage inlet temperatures are an
<em>output</em> of the expansion and cannot be known in advance: run, read the
settled tap temperatures (<code>vols[i].medium.T</code> is stage&nbsp;i+1's inlet),
feed them back, repeat. It converges quickly &mdash; pass&nbsp;1 under the default
sizing gave {641.9, 458.5}&nbsp;K, then 637.0/451.0 &rarr; 623.7/478.3 &rarr;
624.7/474.8, with the RMS falling 0.016 &rarr; 0.00186 &rarr; 0.00022. At the fixed
point <code>T_nominal</code> and the temperatures the stages actually see agree to
under 0.1&nbsp;% (624.6 / 475.2&nbsp;K), and every asserted quantity is within
0.05&nbsp;%.</p>

<p><strong>The two tests carry different thresholds on purpose.</strong> This one
is 0.005 because a correctly-sized machine reproduces its own ladder almost
exactly &mdash; there is no modelling approximation left once <code>T_nominal</code>
is right. <code>MultiStageTurbine_Test</code> is 0.06 because it deliberately keeps
the <em>default</em> <code>Tsat+5</code> sizing, whose residual (&minus;3.6 /
&minus;6.9&nbsp;%) is that approximation. Tightening this one to match that would
hide the very difference the pair exists to show.</p>

<p><strong>If this test fails after a change to the default sizing, that is
expected and not a bug</strong> &mdash; it pins the <em>override</em> path, not the
default. Check <code>MultiStageTurbine_Test</code> first to tell the two apart.</p>
</html>"));
end MultiStageTurbine_Superheat_Test;
