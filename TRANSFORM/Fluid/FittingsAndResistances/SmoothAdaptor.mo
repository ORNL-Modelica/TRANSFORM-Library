within TRANSFORM.Fluid.FittingsAndResistances;
model SmoothAdaptor
  "Gradual (conical) circular adaptor between two diameters (diffuser/confuser minor loss)"
  extends TRANSFORM.Fluid.FittingsAndResistances.BaseClasses.PartialResistancenew;
  input SI.Length dimensions_ab[2]={0.01,0.02}
    "Pipe inner diameters at {port_a,port_b}"
    annotation (Dialog(group="Inputs"));
  parameter SI.Angle angle(displayUnit="deg") = 15*Modelica.Constants.pi/180
    "Cone half-angle (divergence/convergence half-angle)";
  input SI.Length roughness=0 "Average height of surface asperities"
    annotation (Dialog(group="Inputs"));
  SI.ReynoldsNumber Re "Reynolds number (referenced to the smaller section)";
  Units.NonDim K_ab "Minor loss coefficient if flow a->b";
  Units.NonDim K_ba "Minor loss coefficient if flow b->a";
  Units.NonDim K "Minor loss coefficient";
  SI.Velocity v_a "Velocity at port_a";
  SI.Velocity v_b "Velocity at port_b";
  SI.Area crossAreas[2]=0.25*Modelica.Constants.pi*dimensions_ab .*
      dimensions_ab "Cross-sectional area at {port_a,port_b}";
  Real crossAreaRatio=crossAreas[1]/crossAreas[2]
    "Ratio of crossArea_a/crossArea_b";
protected
  SI.Angle angle_total=2*angle "Total included cone angle";
equation
  Re = 4.0*abs(m_flow)/(Modelica.Constants.pi*sqrt(4*min(crossAreas)/
    Modelica.Constants.pi)*Medium.dynamicViscosity(state));
  K = smooth(0, noEvent(if m_flow >= 0 then K_ab else -K_ba));
  dp = K*m_flow^2/(2*Medium.density(state)*min(crossAreas)^2);
  // Flow a->b is a contraction (confuser) when port_a is larger, else an expansion (diffuser).
  K_ab = TRANSFORM.Math.spliceTanh(
    ClosureRelations.PressureLoss.Functions.Diffusers.K_conicalConfuser(
      crossAreas,
      Re,
      angle_total,
      roughness,
      Re_lam,
      Re_turb),
    ClosureRelations.PressureLoss.Functions.Diffusers.K_conicalDiffuser(
      crossAreas,
      Re,
      angle_total,
      roughness,
      Re_lam,
      Re_turb),
    crossAreaRatio - 1.0,
    0.01);
  K_ba = TRANSFORM.Math.spliceTanh(
    ClosureRelations.PressureLoss.Functions.Diffusers.K_conicalDiffuser(
      crossAreas,
      Re,
      angle_total,
      roughness,
      Re_lam,
      Re_turb),
    ClosureRelations.PressureLoss.Functions.Diffusers.K_conicalConfuser(
      crossAreas,
      Re,
      angle_total,
      roughness,
      Re_lam,
      Re_turb),
    crossAreaRatio - 1.0,
    0.01);
  v_a = abs(m_flow)/(Medium.density(state)*crossAreas[1]);
  v_b = abs(m_flow)/(Medium.density(state)*crossAreas[2]);
  annotation (
    defaultComponentName="adaptor",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Polygon(
          points={{-46,20},{44,40},{44,-40},{-46,-20},{-46,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Minor-loss resistance for a <b>smooth (gradual, conical) circular adaptor</b> connecting two pipe diameters. Unlike
<a href=\"modelica://TRANSFORM.Fluid.FittingsAndResistances.SharpEdgedAdaptor\">SharpEdgedAdaptor</a> (an abrupt area
change), this component represents a tapered transition with a finite cone angle, so the losses are substantially lower.</p>
<p>The pressure loss is computed as</p>
<blockquote><code>dp = K*m_flow^2/(2*rho*min(A)^2)</code></blockquote>
<p>referenced to the velocity head in the smaller of the two cross-sections. The coefficient <code>K</code> is selected
by flow direction and geometry, mirroring SharpEdgedAdaptor:</p>
<ul>
<li>flow toward the <b>larger</b> diameter &rarr; gradual expansion
(<a href=\"modelica://TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Diffusers.K_conicalDiffuser\">K_conicalDiffuser</a>);</li>
<li>flow toward the <b>smaller</b> diameter &rarr; gradual contraction
(<a href=\"modelica://TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Diffusers.K_conicalConfuser\">K_conicalConfuser</a>).</li>
</ul>
<p>The two directions are blended smoothly with <code>spliceTanh</code> around the equal-area point, and the design and
reverse coefficients <code>K_ab</code>/<code>K_ba</code> are selected by the sign of the mass flow rate, so flow reversal
is fully supported.</p>
<h4>Geometry</h4>
<ul>
<li><code>dimensions_ab</code> &ndash; pipe inner diameters at <code>port_a</code> and <code>port_b</code>.</li>
<li><code>angle</code> &ndash; cone <b>half</b>-angle of the taper; the closure functions receive the total included
angle <code>2*angle</code>. The implied axial taper length is
<code>L = |d_b - d_a|/(2*tan(angle))</code>.</li>
</ul>
<h4>Notes / range of validity</h4>
<p>Circular cross-sections; turbulent-flow minor-loss correlations (Rennels &amp; Hudson, 2012). As the half-angle
approaches 90&deg; (total angle 180&deg;) the expansion direction reduces to the Borda-Carnot sudden-expansion limit
<code>K = (1 - beta^2)^2</code>. Wall <code>roughness</code> and the laminar/turbulent transition
(<code>Re_lam</code>, <code>Re_turb</code>) are honoured through the friction term.</p>
<h4>References</h4>
<p>Rennels, D. C. &amp; Hudson, H. M. <i>Pipe Flow: A Practical and Comprehensive Guide</i>. John Wiley &amp; Sons (2012).</p>
<p>Cross-check implementation: Bell, C. <i>fluids</i> (open-source),
<code>fluids.fittings.diffuser_conical</code> / <code>contraction_conical</code> (method=\"Rennels\").</p>
</html>"));
end SmoothAdaptor;
