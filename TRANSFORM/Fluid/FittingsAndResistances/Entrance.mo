within TRANSFORM.Fluid.FittingsAndResistances;
model Entrance
  "Pipe entrance loss from a large plenum/reservoir into a pipe (minor loss)"
  extends TRANSFORM.Fluid.FittingsAndResistances.BaseClasses.PartialResistancenew;
  input SI.Length dimension=0.05 "Pipe inner diameter"
    annotation (Dialog(group="Inputs"));
  input Units.NonDim K=0.5 "Entrance loss coefficient (ref. pipe velocity)"
    annotation (Dialog(group="Inputs"));
  SI.Velocity v "Velocity in the pipe";
  SI.Area crossArea=0.25*Modelica.Constants.pi*dimension^2 "Pipe cross-sectional area";
protected
  Units.NonDim K_signed "Signed minor loss coefficient";
equation
  K_signed = smooth(0, noEvent(if m_flow >= 0 then K else -K));
  dp = K_signed*m_flow^2/(2*Medium.density(state)*crossArea^2);
  v = abs(m_flow)/(Medium.density(state)*crossArea);
  annotation (
    defaultComponentName="entrance",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{0,30},{90,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Polygon(
          points={{0,30},{-60,80},{-60,-80},{0,-30},{0,30}},
          lineColor={0,0,0},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Minor-loss resistance for the <b>entrance</b> of a pipe drawing from a large plenum/reservoir. The pressure loss is</p>
<blockquote><code>dp = K*m_flow^2/(2*rho*A^2)</code></blockquote>
<p>referenced to the pipe velocity head, with a user-supplied entrance loss coefficient <code>K</code>. Typical values:</p>
<ul>
<li>sharp-edged (flush): <code>K &asymp; 0.5</code> (Idelchik/Crane) &ndash; default; Rennels recommends 0.57;</li>
<li>slightly rounded: <code>K &asymp; 0.2&ndash;0.25</code>; well-rounded / bellmouth: <code>K &asymp; 0.03&ndash;0.05</code>;</li>
<li>re-entrant (Borda, protruding): <code>K &asymp; 0.78&ndash;1.0</code>;</li>
<li>beveled (45&deg;, moderate): <code>K &asymp; 0.2&ndash;0.3</code>.</li>
</ul>
<p>The loss opposes the flow (design direction is plenum &rarr; pipe). Circular cross-section.</p>
<h4>References</h4>
<p>Idelchik, I. E. <i>Handbook of Hydraulic Resistance</i>, Begell House; Rennels &amp; Hudson, <i>Pipe Flow</i> (2012).</p>
</html>"));
end Entrance;
