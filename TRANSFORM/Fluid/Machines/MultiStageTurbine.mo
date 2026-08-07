within TRANSFORM.Fluid.Machines;
model MultiStageTurbine
  "N-stage steam turbine with an extraction tap between each pair of stages"
  import Modelica.Fluid.Types.Dynamics;
  import SI = Modelica.Units.SI;
  replaceable package Medium = Modelica.Media.Water.StandardWater
    constrainedby Modelica.Media.Interfaces.PartialMedium
    annotation (__Dymola_choicesAllMatching=true);

  parameter Integer nStages(min=1) = 3 "Number of expansion stages";
  parameter Real eta_is = 0.85 "Isentropic efficiency (applied to every stage)";

  parameter SI.Pressure p_nominal[nStages + 1]
    "Boundary pressures {inlet, tap_1, ..., tap_(n-1), outlet}; the interior
     (nStages-1) values are the extraction-tap pressures.";
  parameter SI.MassFlowRate m_flow_nominal[nStages]
    "Per-stage nominal through-flow (sets each stage Stodola coefficient). Stage
     i carries the inlet flow minus all upstream extractions — set each to the
     ACTUAL design through-flow, else the stage is mis-sized (see #74).";

  parameter SI.Temperature T_in_nominal = 520 "Inlet temperature (stage 1)";
  parameter SI.Volume V_tap = 20
    "Each extraction-tap node volume (buffers the IC steam-fill transient).";
  parameter SI.Temperature dT_superheat_nominal = 5
    "Superheat above Tsat used for the DEFAULT T_nominal of stages 2..n"
    annotation (Dialog(tab="Advanced", group="Stodola sizing"));

  // Per-stage nominal inlet T — the temperature at which each stage's Stodola Kt
  // is evaluated. Overridable: the DEFAULT assumes the expansion stays near
  // saturation (inlet T for stage 1, Tsat(p)+dT_superheat_nominal for the rest),
  // which is right for saturated-steam cycles and WRONG for a high-superheat one.
  //
  // Kt ~ m_flow_nominal / sqrt(p*rho(p,T_nominal)), so it goes as 1/sqrt(rho): a
  // stage sized on the wrong density passes sqrt(rho_actual/rho_nominal) of its
  // design flow, backs up, and walks the whole downstream pressure ladder.
  // MEASURED on the 3-stage unit test: with a 773 K / 6 MPa inlet (~224 K
  // superheat) the default puts stage 2's nominal at 490.5 K while it actually
  // sees 642 K — rho 8.08 vs 9.87 kg/m3, 18 % low — and tap 1 lands +15.2 % off
  // the design ladder. Near saturation (570 K, ~21 K superheat) the same test
  // holds the ladder to -3.6 %.
  //
  // SET THIS EXPLICITLY for a superheated expansion: one entry per stage, each
  // the temperature that stage's inlet will actually sit at. Two passes is the
  // practical route — run with the default, read the settled stage inlet
  // temperatures, feed them back.
  parameter SI.Temperature T_nominal[nStages] = cat(
    1,
    {T_in_nominal},
    {Medium.saturationTemperature(p_nominal[i]) + dT_superheat_nominal
     for i in 2:nStages})
    "Per-stage nominal inlet T for the Stodola Kt sizing (see the note above)"
    annotation (Dialog(tab="Advanced", group="Stodola sizing"));

  // Initialization (boundary pressures + enthalpies).
  parameter SI.Pressure p_start[nStages + 1] = p_nominal;
  final parameter SI.SpecificEnthalpy h_start[nStages + 1] = cat(
    1,
    {Medium.specificEnthalpy_pT(p_start[1], T_in_nominal)},
    {Medium.dewEnthalpy(Medium.setSat_p(p_start[i])) - 30e3 for i in 2:nStages},
    {Medium.dewEnthalpy(Medium.setSat_p(p_start[nStages + 1])) - 50e3});

  // Ports
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium)
    "Steam inlet"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
      iconTransformation(extent={{-110,50},{-90,70}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b(redeclare package Medium = Medium)
    "Steam exhaust"
    annotation (Placement(transformation(extent={{90,50},{110,70}}),
      iconTransformation(extent={{90,50},{110,70}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_State drain_extract[nStages - 1](
    redeclare each package Medium = Medium)
    "Mid-stage extraction taps (one between each pair of stages)"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
      iconTransformation(extent={{-10,-110},{10,-90}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a shaft_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
      iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b shaft_b
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
      iconTransformation(extent={{90,-10},{110,10}})));

  // Internals
  TRANSFORM.Fluid.Machines.SteamTurbine stages[nStages](
    redeclare each package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    p_inlet_nominal=p_nominal[1:nStages],
    p_outlet_nominal=p_nominal[2:nStages + 1],
    T_nominal=T_nominal,
    p_a_start=p_start[1:nStages],
    p_b_start=p_start[2:nStages + 1],
    each use_T_start=false,
    h_a_start=h_start[1:nStages],
    h_b_start=h_start[2:nStages + 1],
    redeclare each model Eta_wetSteam =
      TRANSFORM.Fluid.Machines.BaseClasses.WetSteamEfficiency.eta_Constant (
        eta_nominal=eta_is))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  TRANSFORM.Fluid.Volumes.MixingVolume vols[nStages - 1](
    redeclare each package Medium = Medium,
    each nPorts_a=1,
    each nPorts_b=2,
    p_start=p_start[2:nStages],
    each use_T_start=false,
    h_start=h_start[2:nStages],
    each energyDynamics=Dynamics.FixedInitial,
    redeclare each model Geometry =
      TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (
        V=V_tap))
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));

equation
  connect(port_a, stages[1].portHP)
    annotation (Line(points={{-100,60},{-80,60},{-80,6},{-10,6}},
                                                  color={0,127,255}));
  connect(shaft_a, stages[1].shaft_a)
    annotation (Line(points={{-100,0},{-10,0}},                   color={0,0,0}));
  for i in 1:nStages - 1 loop
    connect(stages[i].portLP, vols[i].port_a[1]);
    connect(vols[i].port_b[1], stages[i + 1].portHP);
    connect(vols[i].port_b[2], drain_extract[i]);
    connect(stages[i].shaft_b, stages[i + 1].shaft_a);
  end for;
  connect(stages[nStages].portLP, port_b)
    annotation (Line(points={{10,6},{80,6},{80,60},{100,60}},
                                                 color={0,127,255}));
  connect(stages[nStages].shaft_b, shaft_b)
    annotation (Line(points={{10,0},{100,0}},          color={0,0,0}));

  annotation (
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{58,66},{92,54}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-94,66},{-74,54}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-6,23},{6,-23}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,127,255},
          origin={-68,43},
          rotation=180),
        Rectangle(
          extent={{-96,6},{104,-6}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={160,160,164}),
      Text(extent={{-100,120},{100,100}},textString="%name", lineColor={0,0,0}),
        Polygon(
          points={{-80,26},{-80,-34},{80,-76},{80,76},{-80,26}},
          lineColor={0,0,0},
          fillColor={0,114,208},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-24,38},{24,52},{24,-54},{-24,-42},{-24,38}},
          fillPattern=FillPattern.Solid,
          fillColor={43,156,208},
          pattern=LinePattern.None),
        Polygon(
          points={{28,54},{76,70},{76,-66},{28,-54},{28,54}},
          fillPattern=FillPattern.Solid,
          fillColor={129,183,208},
          pattern=LinePattern.None),
        Polygon(
          points={{-76,22},{-28,36},{-28,-42},{-76,-30},{-76,22}},
          fillPattern=FillPattern.Solid,
          fillColor={0,56,102},
          pattern=LinePattern.None),
        Line(points={{-100,60},{-62,60}}, pattern=LinePattern.None),
        Line(points={{-100,60},{-60,58},{-64,44}}, pattern=LinePattern.None),
        Line(points={{-32,72},{-72,92}}, pattern=LinePattern.None)}),
    Documentation(info="<html>
<p>N-stage steam turbine with an extraction tap between each pair of stages.
The package's only turbine template — a parameterized generalization of the
retired fixed-count <code>HP_turbine</code> / <code>LP_turbine</code>: set
<code>nStages</code> and the array parameters
<code>p_nominal</code> (length nStages+1) and <code>m_flow_nominal</code>
(length nStages); the stage chain, the (nStages-1) tap volumes, and all
connects are generated by a for-loop, so the stage count is data, not
structure.</p>

<p>Topology (nStages = 3 shown):</p>
<pre>
  port_a -> stage[1] -> vol[1] -> stage[2] -> vol[2] -> stage[3] -> port_b
                          |                     |
                          v drain_extract[1]    v drain_extract[2]
</pre>

<h4>Stodola sizing and its validity envelope</h4>
<p>Each stage's flow coefficient is derived from its own nominal point:
<code>Kt<sub>i</sub> = m_flow_nominal[i] / (&radic;(p&middot;&rho;(p_nominal[i],
T_nominal[i])) &middot; f(p_nominal[i+1]/p_nominal[i]))</code>. Two things must be
right per stage, and both have been got wrong in practice:</p>
<ul>
<li><code>m_flow_nominal[i]</code> must be the flow <em>that stage</em> carries —
the inlet flow minus all upstream extractions — not the machine total. Sizing every
stage to the total leaves the downstream ladder 8&ndash;12&nbsp;% low.</li>
<li><code>T_nominal[i]</code> must be on the <strong>vapour</strong> side. Evaluating
at <code>Tsat(p)&minus;5</code> returns the liquid density (~950&nbsp;kg/m&sup3;),
making <code>Kt</code> ~30&times; too small so the stage acts as a near-closed
orifice.</li>
</ul>
<p><strong>The default <code>T_nominal</code> assumes a near-saturated
expansion.</strong> Stage 1 uses <code>T_in_nominal</code>; stages 2..n use
<code>Tsat(p) + dT_superheat_nominal</code>. That suits saturated-steam (nuclear)
cycles. For a high-superheat (fossil) expansion the later stages are sized on the
wrong density &mdash; <code>Kt</code> goes as 1/&radic;&rho;, so the stage passes
&radic;(&rho;<sub>actual</sub>/&rho;<sub>nominal</sub>) of its design flow and the
ladder walks. Measured on the unit test: a 773&nbsp;K / 6&nbsp;MPa inlet puts tap 1
<strong>+15.2&nbsp;%</strong> off, against &minus;3.6&nbsp;% at 570&nbsp;K.
Set <code>T_nominal</code> explicitly in that case &mdash; run once with the
default, read the settled stage inlet temperatures, feed them back.</p>

<p>See <code>Examples.SteamTurbineStodolaTests.MultiStageTurbine_Test</code>
(near-saturated, default sizing) and
<code>MultiStageTurbine_Superheat_Test</code> (high superheat with an explicit
<code>T_nominal</code>).</p>
</html>"));
end MultiStageTurbine;
