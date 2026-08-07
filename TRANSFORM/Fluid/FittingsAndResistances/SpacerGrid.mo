within TRANSFORM.Fluid.FittingsAndResistances;
model SpacerGrid
  "Rod-bundle spacer grid pressure loss (Rehme modified drag-coefficient method)"
  extends TRANSFORM.Fluid.FittingsAndResistances.BaseClasses.PartialResistancenew;
  input Units.NonDim epsilon=0.3
    "Blockage ratio = spacer projected frontal area / bundle flow area"
    annotation (Dialog(group="Inputs"));
  input SI.Area crossArea=1e-3 "Bundle flow (free) area"
    annotation (Dialog(group="Inputs"));
  input SI.Length dimension=0.012 "Bundle hydraulic diameter (for Reynolds number)"
    annotation (Dialog(group="Inputs"));
  SI.ReynoldsNumber Re "Bundle Reynolds number";
  Units.NonDim K "Spacer grid loss coefficient (ref. bundle velocity)";
  SI.Velocity v "Bundle (undisturbed) velocity";
protected
  Units.NonDim K_signed "Signed loss coefficient";
equation
  Re = abs(m_flow)*dimension/(crossArea*Medium.dynamicViscosity(state));
  K = ClosureRelations.PressureLoss.Functions.SpacerGrids.K_spacerGrid_Rehme(epsilon, Re);
  K_signed = smooth(0, noEvent(if m_flow >= 0 then K else -K));
  dp = K_signed*m_flow^2/(2*Medium.density(state)*crossArea^2);
  v = abs(m_flow)/(Medium.density(state)*crossArea);
  annotation (
    defaultComponentName="spacer",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-14,40},{14,-40}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(points={{-14,0},{14,0}}, color={255,255,255}),
        Line(points={{0,40},{0,-40}}, color={255,255,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Pressure loss of a <b>rod-bundle spacer grid</b> using the Rehme (1973) modified drag-coefficient method
(<a href=\"modelica://TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.SpacerGrids.K_spacerGrid_Rehme\">K_spacerGrid_Rehme</a>):</p>
<blockquote><code>dp = K*m_flow^2/(2*rho*A_bundle^2)</code>, &nbsp; <code>K = C_v(Re)&middot;&epsilon;&sup2;</code></blockquote>
<p>referenced to the undisturbed bundle velocity head, where <code>epsilon</code> is the blockage ratio (spacer projected
frontal area / bundle flow area, typically 0.15&ndash;0.5), <code>crossArea</code> is the bundle free-flow area and
<code>dimension</code> is the bundle hydraulic diameter (used for the Reynolds number). The modified drag coefficient
<code>C_v(Re)</code> uses the Cigarini/Schikorr semi-empirical fit of Rehme's chart. A common dominant contributor to
core/fuel-assembly axial pressure drop; stack several in series along a bundle. Flow reversal supported.</p>
<h4>References</h4>
<p>Rehme, K. <i>Pressure Drop Correlations for Fuel Element Spacers</i>, Nuclear Technology <b>17</b> (1973) 15&ndash;23;
Schikorr et&nbsp;al., Nucl. Eng. Des. <b>240</b> (2010) 1830&ndash;1842.</p>
</html>"));
end SpacerGrid;
