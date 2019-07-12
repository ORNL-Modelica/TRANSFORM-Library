within TRANSFORM.Math;
function atan22 "Four quadrant inverse tangent"
  extends Modelica.Math.Icons.AxisCenter;
  input Real y;
  input Real x;
  output SI.Angle theta;
algorithm
  theta:=Modelica.Math.atan2(y, x);

  annotation (derivative(zeroDerivative=x)=atan22_der_y,derivative(zeroDerivative=y)=atan22_der_x,
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{0,-80},{8.93,-67.2},{17.1,-59.3},{27.3,-53.6},{42.1,-49.4},
              {69.9,-45.8},{80,-45.1}}),
        Line(points={{-80,-34.9},{-46.1,-31.4},{-29.4,-27.1},{-18.3,-21.5},{-10.3,
              -14.5},{-2.03,-3.17},{7.97,11.6},{15.5,19.4},{24.3,25},{39,30},{
              62.1,33.5},{80,34.9}}),
        Line(points={{-80,45.1},{-45.9,48.7},{-29.1,52.9},{-18.1,58.6},{-10.2,
              65.8},{-1.82,77.2},{0,80}}),
        Text(
          extent={{-90,-46},{-18,-94}},
          lineColor={192,192,192},
          textString="atan2")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={Line(points={{-100,0},{84,0}}, color={95,95,95}),
          Polygon(
            points={{96,0},{80,6},{80,-6},{96,0}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),Line(
            points={{0,-80},{8.93,-67.2},{17.1,-59.3},{27.3,-53.6},{42.1,-49.4},
            {69.9,-45.8},{80,-45.1}},
            color={0,0,255},
            thickness=0.5),Line(
            points={{-80,-34.9},{-46.1,-31.4},{-29.4,-27.1},{-18.3,-21.5},{-10.3,
            -14.5},{-2.03,-3.17},{7.97,11.6},{15.5,19.4},{24.3,25},{39,30},{
            62.1,33.5},{80,34.9}},
            color={0,0,255},
            thickness=0.5),Line(
            points={{-80,45.1},{-45.9,48.7},{-29.1,52.9},{-18.1,58.6},{-10.2,
            65.8},{-1.82,77.2},{0,80}},
            color={0,0,255},
            thickness=0.5),Text(
            extent={{-32,89},{-10,74}},
            textString="pi",
            lineColor={0,0,255}),Text(
            extent={{-32,-72},{-4,-88}},
            textString="-pi",
            lineColor={0,0,255}),Text(
            extent={{0,55},{20,42}},
            textString="pi/2",
            lineColor={0,0,255}),Line(points={{0,40},{-8,40}}, color={192,192,
          192}),Line(points={{0,-40},{-8,-40}}, color={192,192,192}),Text(
            extent={{0,-23},{20,-42}},
            textString="-pi/2",
            lineColor={0,0,255}),Text(
            extent={{62,-4},{94,-26}},
            lineColor={95,95,95},
            textString="u1, u2"),Line(
            points={{-88,40},{86,40}},
            color={175,175,175}),Line(
            points={{-86,-40},{86,-40}},
            color={175,175,175})}),
    Documentation(info="<html>
<p>
This function returns y = atan2(u1,u2) such that tan(y) = u1/u2 and
y is in the range -pi &lt; y &le; pi. u2 may be zero, provided
u1 is not zero. Usually u1, u2 is provided in such a form that
u1 = sin(y) and u2 = cos(y):
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/atan2.png\">
</p>

</html>"));
end atan22;
