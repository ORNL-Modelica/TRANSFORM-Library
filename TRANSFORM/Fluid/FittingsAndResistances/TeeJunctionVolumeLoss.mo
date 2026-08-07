within TRANSFORM.Fluid.FittingsAndResistances;
model TeeJunctionVolumeLoss
  "Tee/wye junction (mixing volume) with angle-dependent Crane dividing/combining losses"
  import Modelica.Fluid.Types.Dynamics;
  extends TRANSFORM.Fluid.Volumes.BaseClasses.PartialVolume(
    mb=port_1.m_flow + port_2.m_flow + port_3.m_flow,
    Ub=port_1.m_flow*actualStream(port_1.h_outflow) + port_2.m_flow*
        actualStream(port_2.h_outflow) + port_3.m_flow*actualStream(port_3.h_outflow),
    mXib=port_1.m_flow*actualStream(port_1.Xi_outflow) + port_2.m_flow*
        actualStream(port_2.Xi_outflow) + port_3.m_flow*actualStream(port_3.Xi_outflow),
    mCb=port_1.m_flow*actualStream(port_1.C_outflow) + port_2.m_flow*
        actualStream(port_2.C_outflow) + port_3.m_flow*actualStream(port_3.C_outflow));

  // Geometry
  input SI.Length d_run=0.05 "Run (straight-through) pipe inner diameter {port_1,port_2}"
    annotation (Dialog(group="Inputs"));
  input SI.Length d_branch=0.05 "Branch pipe inner diameter {port_3}"
    annotation (Dialog(group="Inputs"));
  parameter SI.Angle angle(displayUnit="deg") = Modelica.Constants.pi/2
    "Angle the branch makes with the straight-through run (tee=90 deg, wye<90 deg)";
  parameter SI.MassFlowRate m_flow_reg=1e-4
    "Mass flow rate width for smoothing the dividing<->combining transition"
    annotation (Dialog(tab="Advanced"));
  parameter Real Rnom(unit="Pa.s/kg") = 1e5
    "Nominal linear resistance used only for homotopy initialization"
    annotation (Dialog(tab="Advanced"));

  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_1(redeclare package Medium =
        Medium) "Combined leg (run inlet for dividing flow)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_2(redeclare package Medium =
        Medium) "Run leg (straight-through)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_3(redeclare package Medium =
        Medium) "Branch leg"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  Units.NonDim K_run "Applied run loss coefficient (ref. combined velocity head)";
  Units.NonDim K_branch "Applied branch loss coefficient (ref. combined velocity head)";
protected
  SI.Area A_run=0.25*Modelica.Constants.pi*d_run^2 "Run cross-sectional area";
  SI.VolumeFlowRate V_run=abs(port_2.m_flow)/medium.d "Run-leg volumetric flow";
  SI.VolumeFlowRate V_branch=abs(port_3.m_flow)/medium.d "Branch-leg volumetric flow";
  SI.Pressure hd=0.5*port_1.m_flow^2/(medium.d*A_run^2)
    "Combined-flow dynamic head (1/2 rho w_c^2)";
  // Crane coefficients for both flow directions
  Units.NonDim Kr_div=TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Tees.K_runDiverging_Crane(
      d_run, d_branch, V_run, V_branch, angle);
  Units.NonDim Kb_div=TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Tees.K_branchDiverging_Crane(
      d_run, d_branch, V_run, V_branch, angle);
  Units.NonDim Kr_conv=TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Tees.K_runConverging_Crane(
      d_run, d_branch, V_run, V_branch, angle);
  Units.NonDim Kb_conv=TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Tees.K_branchConverging_Crane(
      d_run, d_branch, V_run, V_branch, angle);
equation
  // Only one connection allowed per port to avoid unwanted ideal mixing
  assert(cardinality(port_1) <= 1, "port_1 can at most be connected to one component.");
  assert(cardinality(port_2) <= 1, "port_2 can at most be connected to one component.");
  assert(cardinality(port_3) <= 1, "port_3 can at most be connected to one component.");

  // Reported (direction-selected) coefficients
  K_run = TRANSFORM.Math.spliceTanh(Kr_div, Kr_conv, port_1.m_flow, m_flow_reg);
  K_branch = TRANSFORM.Math.spliceTanh(Kb_div, Kb_conv, port_1.m_flow, m_flow_reg);

  // Momentum / pressure: combined leg is the junction reference; run and branch
  // legs drop (dividing, port_1.m_flow>0) or rise (combining, port_1.m_flow<0)
  // by the Crane loss, smoothly blended about zero combined flow.
  port_1.p = medium.p;
  port_2.p = medium.p - homotopy(TRANSFORM.Math.spliceTanh(Kr_div*hd, -Kr_conv*
    hd, port_1.m_flow, m_flow_reg), -Rnom*port_2.m_flow);
  port_3.p = medium.p - homotopy(TRANSFORM.Math.spliceTanh(Kb_div*hd, -Kb_conv*
    hd, port_1.m_flow, m_flow_reg), -Rnom*port_3.m_flow);

  // Boundary conditions (ideal mixing in the volume)
  port_1.h_outflow = medium.h;
  port_2.h_outflow = medium.h;
  port_3.h_outflow = medium.h;
  port_1.Xi_outflow = medium.Xi;
  port_2.Xi_outflow = medium.Xi;
  port_3.Xi_outflow = medium.Xi;
  port_1.C_outflow = C;
  port_2.C_outflow = C;
  port_3.C_outflow = C;
  annotation (
    defaultComponentName="tee",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-40,90},{40,40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor=DynamicSelect({0,128,255}, if showColors then dynColor else {0,128,255})),
        Rectangle(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor=DynamicSelect({0,128,255}, if showColors then dynColor else {0,128,255})),
        Ellipse(
          extent={{-9,10},{11,-10}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-44},{151,-84}},
          textColor={0,0,255},
          textString="%name",
          visible=showName)}),
    Documentation(info="<html>
<p>A tee/wye junction with a central ideal-mixing volume (like
<a href=\"modelica://TRANSFORM.Fluid.FittingsAndResistances.TeeJunctionVolume\">TeeJunctionVolume</a>) <b>plus</b>
angle-dependent junction losses on the run and branch legs, using the Crane TP-410 correlations. This captures the loss
of a pipe taking off the run at an angle (e.g. a 90&deg; branch) including its dependence on take-off angle, area ratio
and flow split &ndash; which a simple area-change resistance on the leg cannot.</p>
<h4>Ports &amp; convention</h4>
<ul>
<li><code>port_1</code> &ndash; combined leg (run inlet for dividing flow / run outlet for combining flow), diameter <code>d_run</code>;</li>
<li><code>port_2</code> &ndash; run / straight-through leg, diameter <code>d_run</code>;</li>
<li><code>port_3</code> &ndash; branch leg at <code>angle</code> to the run, diameter <code>d_branch</code>.</li>
</ul>
<p>The branch and run loss coefficients are referenced to the <b>combined</b>-leg velocity head
<code>&frac12;&rho;w_c&sup2;</code> (with <code>w_c</code> the velocity in <code>port_1</code>). Both the dividing
(<code>port_1.m_flow &gt; 0</code>) and combining (<code>port_1.m_flow &lt; 0</code>) correlation sets are evaluated and
blended smoothly about zero combined flow with <code>spliceTanh</code>, so flow reversal is supported. Note that the run
and combined diameters are assumed equal (Crane model); the branch may be a different size. Loss coefficients can be
slightly negative (pressure recovery), consistent with the correlations.</p>
<h4>References</h4>
<p>Crane Co. <i>Flow of Fluids Through Valves, Fittings, and Pipe</i> (Technical Paper No. 410), 2009. Closures:
<a href=\"modelica://TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Tees\">ClosureRelations...Functions.Tees</a>.</p>
</html>"));
end TeeJunctionVolumeLoss;
