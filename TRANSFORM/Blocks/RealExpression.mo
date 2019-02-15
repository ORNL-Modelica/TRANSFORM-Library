within TRANSFORM.Blocks;
block RealExpression
  "Set input signal to a time varying Real expression"
  Modelica.Blocks.Interfaces.RealInput u "Value of Real output"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Real y = u;
  annotation (Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          lineThickness=5,
          fillColor={196,235,205},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-96,15},{96,-15}},
          lineColor={0,0,0},
          textString="%u"),
        Text(
          extent={{-150,90},{140,50}},
          textString="%name",
          lineColor={0,0,255})}));
end RealExpression;
