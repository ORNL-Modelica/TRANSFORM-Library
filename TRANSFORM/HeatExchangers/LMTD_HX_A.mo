within TRANSFORM.HeatExchangers;
model LMTD_HX_A "Calculate A using LMTD method"
  extends TRANSFORM.HeatExchangers.BaseClasses.Partial_LMTD_HX;

  parameter SI.Power Q_flow0=0.5e6;
  input SI.CoefficientOfHeatTransfer alpha_1 = 800 annotation(Dialog(group="Inputs"));
  input SI.CoefficientOfHeatTransfer alpha_2 = 4000 annotation(Dialog(group="Inputs"));

  SI.Area surfaceArea(start=1);

equation

  UA = 1/(1/(alpha_1*surfaceArea) + 1/(alpha_2*surfaceArea));

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
end LMTD_HX_A;
