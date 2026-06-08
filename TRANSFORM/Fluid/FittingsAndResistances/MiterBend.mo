within TRANSFORM.Fluid.FittingsAndResistances;
model MiterBend
  "Single-joint mitered (sharp) pipe bend (minor loss)"
  extends TRANSFORM.Fluid.FittingsAndResistances.BaseClasses.PartialResistancenew;
  input SI.Length dimension=0.05 "Pipe inner diameter"
    annotation (Dialog(group="Inputs"));
  parameter SI.Angle angle(displayUnit="deg") = Modelica.Constants.pi/2
    "Bend deflection (turning) angle";
  Units.NonDim K "Minor loss coefficient";
  SI.Velocity v "Velocity in the pipe";
  SI.Area crossArea=0.25*Modelica.Constants.pi*dimension^2
    "Pipe cross-sectional area";
protected
  Units.NonDim K_signed "Signed minor loss coefficient";
equation
  K = ClosureRelations.PressureLoss.Functions.Bends.K_miterBend(angle);
  K_signed = smooth(0, noEvent(if m_flow >= 0 then K else -K));
  dp = K_signed*m_flow^2/(2*Medium.density(state)*crossArea^2);
  v = abs(m_flow)/(Medium.density(state)*crossArea);
  annotation (
    defaultComponentName="miter",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Polygon(
          points={{-80,-12},{-16,-12},{14,40},{40,40},{-2,-32},{-2,-12},{-80,-12}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Minor-loss resistance for a single-joint <b>mitered (sharp) pipe bend</b> &ndash; a pipe that changes direction at a
sharp joint with no curvature radius. The pressure loss is</p>
<blockquote><code>dp = K*m_flow^2/(2*rho*A^2)</code></blockquote>
<p>with the resistance coefficient from the Rennels &amp; Hudson (2012) correlation
(<a href=\"modelica://TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Bends.K_miterBend\">K_miterBend</a>),
<code>K = 0.42 sin(&alpha;/2) + 2.56 sin&sup3;(&alpha;/2)</code>, valid to about 150&deg;. A mitered bend is markedly more
lossy than a smooth bend (<a href=\"modelica://TRANSFORM.Fluid.FittingsAndResistances.Elbow\">Elbow</a>) of the same
angle. Flow reversal is supported (the loss opposes the flow). Circular cross-section.</p>
<h4>References</h4>
<p>Rennels, D. C. &amp; Hudson, H. M. <i>Pipe Flow: A Practical and Comprehensive Guide</i>. John Wiley &amp; Sons (2012).</p>
</html>"));
end MiterBend;
