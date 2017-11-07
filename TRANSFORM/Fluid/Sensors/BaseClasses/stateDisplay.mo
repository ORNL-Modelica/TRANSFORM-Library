within TRANSFORM.Fluid.Sensors.BaseClasses;
model stateDisplay

  extends TRANSFORM.Icons.UnderConstruction;

  parameter Integer precision_p=2 "Pressure"
   annotation(Evaluate=true,Dialog(group="Set Number of Displayed Significant Digits"));
  parameter Integer precision_h=1 "Specific enthalpy"
   annotation(Evaluate=true,Dialog(group="Set Number of Displayed Significant Digits"));
  parameter Integer precision_T=1 "Temperature"
   annotation(Evaluate=true,Dialog(group="Set Number of Displayed Significant Digits"));
  parameter Integer precision_m_flow=1 "Mass flow rate"
   annotation(Evaluate=true,Dialog(group="Set Number of Displayed Significant Digits"));

  TRANSFORM.Fluid.Sensors.BaseClasses.statePort statePort annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}), iconTransformation(extent={{
            -5,-31},{5,-21}})));

  Real h_out(unit="kJ/kg");
  Real p(unit="bar");
  Real m_flow(unit="kg/s");
  Real T(unit="degC");

equation
  h_out = statePort.h_out/1000;
  p = statePort.p/1e5;
  m_flow = statePort.m_flow;
  T = statePort.T - 273.15;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={
        Rectangle(
          extent={{-100,30},{100,-26}},
          lineColor={175,175,175},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,30},{0,-26}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{100,0},{-100,0}},
          color={95,95,95},
          smooth=Smooth.None),
        Text(extent={{-83,4},{-18,26}}, textString=DynamicSelect("0.0",
              String(
              h_out,
              format="3."+String(precision_h)+"f"))),
        Text(extent={{25,4},{75,26}},  textString=DynamicSelect("0.0",
              String(
              p,
              format="3."+String(precision_p)+"f"))),
        Text(extent={{-77,-29},{-25,-7}},
                                       textString=DynamicSelect("0.0",
              String(
              m_flow,
              format="3."+String(precision_m_flow)+"f"))),
        Text(extent={{15,-29},{86,-7}},textString=DynamicSelect("0.0",
              String(
              T,
              1,
              format="3."+String(precision_T)+"f"))),
        Text(
          extent={{-92,53},{-10,37}},
          lineColor={28,108,200},
          textString="h (kJ/kg)"),
        Text(
          extent={{16,53},{84,37}},
          lineColor={28,108,200},
          textString="p (bar)"),
        Text(
          extent={{-92,-36},{-8,-48}},
          lineColor={28,108,200},
          textString="m_flow (kg/s)"),
        Text(
          extent={{10,-34},{90,-48}},
          lineColor={28,108,200},
          textString="T (degC)")}));
end stateDisplay;
