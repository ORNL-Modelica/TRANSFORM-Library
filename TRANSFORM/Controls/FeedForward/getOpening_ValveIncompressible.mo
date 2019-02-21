within TRANSFORM.Controls.FeedForward;
model getOpening_ValveIncompressible
  "Reverse calculate the valve input (opening) required to reach a certain mass flow rate"
 extends Modelica.Blocks.Interfaces.SO;
 extends TRANSFORM.Fluid.Valves.BaseClasses.PartialValveBase;
 input Modelica.SIunits.Pressure dp "Pressure drop" annotation(Dialog(group="Inputs"));
 input Modelica.SIunits.MassFlowRate m_flow_ref "Reference mass flow" annotation(Dialog(group="Inputs"));
 input Modelica.SIunits.Density d=d_nom "Density" annotation(Dialog(group="Inputs"));
  Real z "Normalized pressure drop";
  Real sqrtz "Root of normalized pressure drop";
equation
  z = dp/dp_nom;
  sqrtz = noEvent(z/sqrt(abs(z) + b));
  m_flow_ref = valveCharacteristic(y)*Av_internal*sqrt(d*dp_nom)*sqrtz;
  //m_flow_ref = valveCharacteristic(y)*Av_internal*sqrt(d)*Modelica.Fluid.Utilities.regRoot(dp_nom)
  annotation (defaultComponentName="getOpening",
          Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                          Text(
          extent={{-60,58},{54,-58}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="output
=
f(inputs)")}),
Diagram(coordinateSystem(preserveAspectRatio=false)));
end getOpening_ValveIncompressible;
