within TRANSFORM.Blocks;
block ArrayToMatrix
  parameter Integer n=1;
  parameter Integer nrows=1;
  parameter Integer ncolumns=1;
  Modelica.Blocks.Interfaces.RealInput u[n] annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y[nrows,ncolumns]
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  for ii in 1:nrows loop
    for jj in 1:ncolumns loop
      y[ii, jj] = u[nrows*(ii - 1) + jj];
    end for;
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,20},{100,-20}},
          textColor={28,108,200},
          textString="[] -> [ , ]")}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end ArrayToMatrix;
