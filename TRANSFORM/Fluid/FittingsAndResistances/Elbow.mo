within TRANSFORM.Fluid.FittingsAndResistances;
model Elbow
  "Smooth circular pipe bend / elbow (minor loss, local + arc friction)"
  extends TRANSFORM.Fluid.FittingsAndResistances.BaseClasses.PartialResistancenew;
  input SI.Length dimension=0.05 "Pipe inner diameter"
    annotation (Dialog(group="Inputs"));
  input SI.Length radius=1.5*dimension
    "Bend radius of curvature (to the pipe centerline)"
    annotation (Dialog(group="Inputs"));
  parameter SI.Angle angle(displayUnit="deg") = Modelica.Constants.pi/2
    "Bend deflection (turning) angle";
  input SI.Length roughness=0 "Average height of surface asperities"
    annotation (Dialog(group="Inputs"));
  SI.ReynoldsNumber Re "Reynolds number";
  Units.NonDim K "Minor loss coefficient";
  SI.Velocity v "Velocity in the pipe";
  SI.Area crossArea=0.25*Modelica.Constants.pi*dimension^2
    "Pipe cross-sectional area";
protected
  Units.NonDim K_signed "Signed minor loss coefficient";
equation
  Re = 4.0*abs(m_flow)/(Modelica.Constants.pi*dimension*Medium.dynamicViscosity(
    state));
  K = ClosureRelations.PressureLoss.Functions.Bends.K_smoothBend(
    dimension,
    radius,
    angle,
    Re,
    roughness,
    Re_lam,
    Re_turb);
  K_signed = smooth(0, noEvent(if m_flow >= 0 then K else -K));
  dp = K_signed*m_flow^2/(2*Medium.density(state)*crossArea^2);
  v = abs(m_flow)/(Medium.density(state)*crossArea);
  annotation (
    defaultComponentName="elbow",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Polygon(
          points={{-46,26},{-46,30},{-36,30},{24,30},{24,-34},{24,-40},{20,-40},
              {-12,-40},{-16,-40},{-16,-30},{-16,-10},{-36,-10},{-46,-10},{-46,
              -6},{-46,26}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Minor-loss resistance for a <b>smooth circular pipe bend (elbow)</b>. The pressure loss is computed as</p>
<blockquote><code>dp = K*m_flow^2/(2*rho*A^2)</code></blockquote>
<p>where <code>A</code> is the pipe cross-sectional area and the resistance coefficient <code>K</code> is given by the
Rennels &amp; Hudson (2012) smooth-bend correlation
(<a href=\"modelica://TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Bends.K_smoothBend\">K_smoothBend</a>),
combining an arc-friction term, the primary turning loss, and a secondary-flow (Dean-vortex) term. The Darcy
friction factor used in the friction terms is evaluated from the existing single-phase 2-region correlation, so wall
<code>roughness</code> and the laminar/turbulent transition (<code>Re_lam</code>, <code>Re_turb</code>) are honoured.</p>
<h4>Geometry</h4>
<ul>
<li><code>dimension</code> &ndash; pipe inner diameter <code>D</code>.</li>
<li><code>radius</code> &ndash; bend radius of curvature <code>rc</code> measured to the pipe centerline; the relative
bend radius is <code>rc/D</code>.</li>
<li><code>angle</code> &ndash; deflection (turning) angle; defaults to 90&deg;.</li>
</ul>
<h4>Notes / range of validity</h4>
<p>The correlation is referenced to the (constant) pipe velocity head and applies to circular cross-sections. It is a
turbulent-flow minor-loss correlation; at very low Reynolds number the friction contribution dominates and the model
remains well-behaved (the friction factor uses an internal Reynolds-number floor). Flow reversal is supported: the
loss always opposes the flow direction.</p>
<h4>References</h4>
<p>Rennels, D. C. &amp; Hudson, H. M. <i>Pipe Flow: A Practical and Comprehensive Guide</i>. John Wiley &amp; Sons (2012).</p>
<p>Cross-check implementation: Bell, C. <i>fluids</i> (open-source), <code>fluids.fittings.bend_rounded(method=\"Rennels\")</code>.</p>
</html>"));
end Elbow;
