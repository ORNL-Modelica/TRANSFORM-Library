within TRANSFORM.Controls.FeedForward;
model getRPM_centrifugalPump
  "Reverse calculates the rotational speed (y=omega_RPM) that is required for the pump flow=m_flow_ref"
 extends Modelica.Blocks.Interfaces.SO(y(start=1100));
 import solveLSQ = Modelica.Math.Matrices.leastSquares;
 parameter Modelica.SIunits.VolumeFlowRate q_nom[:]={0.0,0.001,0.0015}
    "Volume flow rate for given operating points (single pump)"
    annotation (Dialog(group="Nominal pump characteristic"));
 parameter Modelica.SIunits.Height head_nom[size(q_nom, 1)]={60,30,0}
    "Pump head for given operating points"
    annotation (Dialog(group="Nominal pump characteristic"));
 parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm omega_RPM_nom=
      1500 "Nominal rotational speed"
    annotation (Dialog(group="Nominal operating point"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nom=1 "Mass flowrate start value (single pump)"
    annotation (Dialog(tab="Initialization"));
  parameter SI.Density d_nom=1000 "Nominal Liquid Density"
    annotation (Dialog(group="Nominal operating point"));
 input Modelica.SIunits.MassFlowRate m_flow_ref "Reference mass flow" annotation(Dialog(group="Inputs"));
 input Modelica.SIunits.Density d_inlet=d_nom "Pump inlet density" annotation(Dialog(group="Inputs"));
 input Real dp "Pump pressure head" annotation(Dialog(group="Inputs"));
 parameter Boolean explicitCalculation=true "If false let tool solve second order equation";
 constant Modelica.SIunits.Acceleration g=Modelica.Constants.g_n;
 Real a,b,c; // a*n^2+b*b+c=0
 Real ABC[3] "Pump characteristics polynominal";
equation
  // Calculation of pump characteristics
   ABC=solveLSQ([{q_nom[i]^2 for i in 1:size(q_nom, 1)}, q_nom, ones(
      size(q_nom, 1), 1)], g*head_nom);
  c=m_flow_ref^2/d_inlet*ABC[1]-dp;
  b=m_flow_ref/omega_RPM_nom*ABC[2];
  a=d_inlet/omega_RPM_nom^2*ABC[3];
  if explicitCalculation then
    // Choose largest root
    y=(-b+sqrt(b^2-4*a*c))/(2*a); // general second order solution
  else
    dp = (ABC[1]*(m_flow_ref*m_flow_ref/(d_inlet*d_inlet)) + ABC[2]*(y/omega_RPM_nom)*m_flow_ref
      /d_inlet + ABC[3]*(y^2/(omega_RPM_nom*omega_RPM_nom)))*d_inlet;
  end if;
  annotation (defaultComponentName="getRPM",
          Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                          Text(
          extent={{-58,58},{56,-58}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="output
=
f(inputs)"),
        Text(
          extent={{-102,-116},{104,-128}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
</html>"));
end getRPM_centrifugalPump;
