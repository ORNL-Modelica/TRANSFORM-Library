within TRANSFORM.Fluid.FittingsAndResistances;
model Exit
  "Pipe exit loss from a pipe into a large plenum/reservoir (minor loss)"
  extends TRANSFORM.Fluid.FittingsAndResistances.BaseClasses.PartialResistancenew;
  input SI.Length dimension=0.05 "Pipe inner diameter"
    annotation (Dialog(group="Inputs"));
  input Units.NonDim K=1.0 "Exit loss coefficient (ref. pipe velocity)"
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
    defaultComponentName="exit",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-90,30},{0,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Polygon(
          points={{0,30},{60,80},{60,-80},{0,-30},{0,30}},
          lineColor={0,0,0},
          fillColor={207,207,207},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Minor-loss resistance for the <b>exit</b> of a pipe discharging into a large plenum/reservoir. The pressure loss is</p>
<blockquote><code>dp = K*m_flow^2/(2*rho*A^2)</code></blockquote>
<p>referenced to the pipe velocity head. For a submerged discharge into a large quiescent volume essentially all of the
kinetic energy is dissipated, so <code>K = 1</code> (default). (Occasionally <code>K&asymp;2</code> for laminar flow, or
slightly above 1 for turbulent profiles.) The loss opposes the flow (design direction is pipe &rarr; plenum). Circular
cross-section.</p>
<h4>References</h4>
<p>Rennels &amp; Hudson, <i>Pipe Flow: A Practical and Comprehensive Guide</i> (2012); Idelchik, <i>Handbook of Hydraulic Resistance</i>.</p>
</html>"));
end Exit;
