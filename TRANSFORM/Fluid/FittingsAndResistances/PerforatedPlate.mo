within TRANSFORM.Fluid.FittingsAndResistances;
model PerforatedPlate
  "Perforated plate / multi-hole orifice in a pipe (minor loss)"
  extends TRANSFORM.Fluid.FittingsAndResistances.BaseClasses.PartialResistancenew;
  input SI.Length dimension=0.05 "Pipe (face) inner diameter"
    annotation (Dialog(group="Inputs"));
  parameter Boolean use_porosity=true
    "=true to specify the open-area ratio directly, else from hole count and size"
    annotation (Evaluate=true);
  input Units.NonDim porosity=0.3 "Open-area ratio = total hole area / face area"
    annotation (Dialog(group="Inputs", enable=use_porosity));
  parameter Integer nHoles=50 "Number of holes"
    annotation (Dialog(enable=not use_porosity));
  input SI.Length diameter_hole=0.005 "Diameter of a single hole"
    annotation (Dialog(group="Inputs", enable=not use_porosity));
  Units.NonDim K "Minor loss coefficient (ref. full-pipe velocity)";
  SI.Velocity v "Velocity in the full pipe";
  SI.Area crossArea=0.25*Modelica.Constants.pi*dimension^2 "Face cross-sectional area";
  Real areaRatio=if use_porosity then porosity else nHoles*(diameter_hole/
      dimension)^2 "Open-area ratio";
protected
  Units.NonDim K_signed "Signed minor loss coefficient";
equation
  K = ClosureRelations.PressureLoss.Functions.Orifices.K_thinOrifice(areaRatio);
  K_signed = smooth(0, noEvent(if m_flow >= 0 then K else -K));
  dp = K_signed*m_flow^2/(2*Medium.density(state)*crossArea^2);
  v = abs(m_flow)/(Medium.density(state)*crossArea);
  annotation (
    defaultComponentName="plate",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-90,40},{90,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-5,40},{5,-40}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(points={{-5,24},{5,24}}, color={255,255,255}),
        Line(points={{-5,8},{5,8}}, color={255,255,255}),
        Line(points={{-5,-8},{5,-8}}, color={255,255,255}),
        Line(points={{-5,-24},{5,-24}}, color={255,255,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Minor-loss resistance for a <b>perforated plate</b> (multi-hole orifice / flow distributor) in a pipe. The loss uses
the same thin-orifice correlation as a single orifice but with the <b>total</b> open-area ratio (porosity):</p>
<blockquote><code>dp = K*m_flow^2/(2*rho*A_face^2)</code>, &nbsp;
<code>K = [1 + 0.707&radic;(1-a) - a]&sup2;/a&sup2;</code></blockquote>
<p>referenced to the full (face) pipe velocity, where <code>a</code> is the open-area ratio &ndash; either given directly
as <code>porosity</code>, or computed from <code>nHoles</code> and <code>diameter_hole</code>
(<code>a = nHoles&middot;(d_hole/d_pipe)&sup2;</code>). Common for core inlet plates and flow distributors. Symmetric;
circular face; thin-plate (no hole-length friction).</p>
<h4>References</h4>
<p>Idelchik, I. E. <i>Handbook of Hydraulic Resistance</i>, Begell House (perforated plate / sharp-edged orifice).</p>
</html>"));
end PerforatedPlate;
