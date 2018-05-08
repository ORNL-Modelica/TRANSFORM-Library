within TRANSFORM.Blocks;
model ShapeFactor "Return output array by shaping a scaler input"

  parameter Integer n=1 "Output array size";

  parameter Real SF_start[n] = fill(1/n,n) "Initial shape function, sum(SF) = 1";
  input Real dSF[n] = fill(0,n) "Change in shape function" annotation(Dialog(group="Inputs"));
  Real SF[n] = SF_start + dSF "Shape function";

  Modelica.Blocks.Interfaces.RealInput u "Scalar input"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[n] "Shaped array output"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation

  assert(abs(1-sum(SF)) < Modelica.Constants.eps, "sum(SF) is not equal to 1");

  y = u*SF;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-60,0},{60,0}}, color={0,0,0}),
        Line(
          points={{-60,-20},{-40,-18},{-26,-10},{-10,4},{2,16},{20,30},{36,22},{
              48,6},{56,-8},{60,-20}},
          color={255,0,0},
          smooth=Smooth.Bezier),
        Text(
          extent={{-150,140},{150,100}},
          textString="%name",
          lineColor={0,0,255}),
        Polygon(
          points={{-80,80},{-88,58},{-72,58},{-80,80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{82,-80}}, color={192,192,192}),
        Line(points={{-80,58},{-80,-80}}, color={192,192,192}),
        Text(
          extent={{-72,46},{-46,20}},
          lineColor={0,0,0},
          textString="u"),
        Text(
          extent={{46,46},{72,20}},
          lineColor={238,46,47},
          textString="y")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end ShapeFactor;
