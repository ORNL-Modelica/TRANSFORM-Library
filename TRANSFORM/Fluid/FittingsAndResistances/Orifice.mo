within TRANSFORM.Fluid.FittingsAndResistances;
model Orifice
  "Thin square-edged orifice plate in a pipe (minor loss)"
  extends TRANSFORM.Fluid.FittingsAndResistances.BaseClasses.PartialResistancenew;
  input SI.Length dimension=0.05 "Pipe inner diameter"
    annotation (Dialog(group="Inputs"));
  input SI.Length diameter_orifice=0.025 "Orifice bore diameter"
    annotation (Dialog(group="Inputs"));
  Units.NonDim K "Minor loss coefficient (ref. full-pipe velocity)";
  SI.Velocity v "Velocity in the full pipe";
  Real areaRatio=(diameter_orifice/dimension)^2 "Open-area ratio (bore/pipe)";
  SI.Area crossArea=0.25*Modelica.Constants.pi*dimension^2
    "Full pipe cross-sectional area";
protected
  Units.NonDim K_signed "Signed minor loss coefficient";
equation
  K = ClosureRelations.PressureLoss.Functions.Orifices.K_thinOrifice(areaRatio);
  K_signed = smooth(0, noEvent(if m_flow >= 0 then K else -K));
  dp = K_signed*m_flow^2/(2*Medium.density(state)*crossArea^2);
  v = abs(m_flow)/(Medium.density(state)*crossArea);
  annotation (
    defaultComponentName="orifice",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-90,30},{90,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-6,30},{6,14}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-6,-14},{6,-30}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Minor-loss resistance for a <b>thin square-edged orifice plate</b> of bore diameter <code>diameter_orifice</code> in a
pipe of diameter <code>dimension</code>. The pressure loss is</p>
<blockquote><code>dp = K*m_flow^2/(2*rho*A_pipe^2)</code></blockquote>
<p>with the resistance coefficient referenced to the full-pipe velocity head and given by the Idelchik thin-orifice
correlation (<a href=\"modelica://TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Orifices.K_thinOrifice\">K_thinOrifice</a>),
<code>K = [1 + 0.707&radic;(1-a) - a]&sup2;/a&sup2;</code> with <code>a = (d_orifice/d_pipe)&sup2;</code>. Orifices are very
lossy at small openings (a=0.5 &rarr; K&asymp;4, a=0.2 &rarr; K&asymp;51). Symmetric thin plate &ndash; loss is the same in
either flow direction and opposes the flow. Circular cross-section; thin-plate (no bore-length friction).</p>
<h4>References</h4>
<p>Idelchik, I. E. <i>Handbook of Hydraulic Resistance</i>, Begell House.</p>
</html>"));
end Orifice;
