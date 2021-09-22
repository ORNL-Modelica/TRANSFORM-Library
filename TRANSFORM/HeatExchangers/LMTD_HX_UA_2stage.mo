within TRANSFORM.HeatExchangers;
model LMTD_HX_UA_2stage
  "2-stage condensing, LMTD subcooling heat exchanger"
  extends TRANSFORM.HeatExchangers.BaseClasses.Partial_2stage_HX(UA(start=1e5));

input SI.ThermalConductance UA0 annotation(Dialog(group="Inputs"));
input SI.QualityFactor condensate_quality0 = 0.0 "Condensation Outlet State" annotation(Dialog(group="Inputs"));
input Real convection_effectiveness0 = 1.0 annotation(Dialog(group="Inputs"));

// protected
//   SI.Temperature T_max = max(max(sensor_T_a1.T,sensor_T_b1.T),max(sensor_T_a2.T,sensor_T_b2.T));
//   SI.Temperature T_min = min(min(sensor_T_a1.T,sensor_T_b1.T),min(sensor_T_a2.T,sensor_T_b2.T));
//   SI.TemperatureDifference dT_1 = abs(sensor_T_a1.T-sensor_T_b1.T);
//   SI.TemperatureDifference dT_2 = abs(sensor_T_a2.T-sensor_T_b2.T);
//   SI.TemperatureDifference dT_max = T_max - T_min;
//   SIadd.NonDim epsilon_1 = dT_1/dT_max;
//   SIadd.NonDim epsilon_2 = dT_2/dT_max;

equation
//   epsilon = max(epsilon_1,epsilon_2);
UA = UA0;
condensate_quality = condensate_quality0;
convection_effectiveness = convection_effectiveness0;
  annotation (defaultComponentName="lmtd_HX",Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-88,-40},{-60,-40},{-30,0},{0,-40},{30,0},{60,-40},{88,-40}},
            color={28,108,200}),
        Line(points={{-88,40},{-30,40},{0,0},{30,40},{88,40}},     color={238,46,
              47}),
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),               Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Assumption:</p>
<p>Side 1 is hot side (i.e,. if Q_flow &lt; 0 then heat is going from Side 1 to Side 2)</p>
</html>"));
end LMTD_HX_UA_2stage;
