within TRANSFORM.Examples.Utilities;
model BoundaryCheck "Check for equivalent boundary conditions"

  parameter Integer n = 1 "Number of comparisons";

  parameter Real[n] x1 "Parameters 1";
  parameter Real[n] x2 "Parameters 2";
  parameter Real[n] tol = fill(Modelica.Constants.eps,n) "Tolerance for equality";
  parameter Boolean[n] isFlow = fill(false,n) "=true for flow variable (i.e., err = x1 + x2 else err = x1 - x2)";

  Real[n] err "Error for x1 - x2";
  Boolean[n] passed "=true if error > tolerance";
  Boolean passedAll "=true if all passed";

equation
  for i in 1:n loop
    if isFlow[i] then
      err[i] = x1[i] + x2[i];
    else
      err[i] = x1[i]-x2[i];
    end if;
    passed[i] = if abs(err[i]) <= tol[i] then true else false;
  end for;

  passedAll = Modelica.Math.BooleanVectors.allTrue(passed);

  annotation (defaultComponentName="BCcheck",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          lineColor={0,0,255},
          extent={{-148,58},{152,98}},
          textString="%name"),
        Rectangle(
          extent={{-60,8},{60,-92}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-48,-4},{48,-80}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-14,-12},{-14,-16},{-8,-30},{-2,-50},{0,-52},{4,-34},{14,-10},
              {24,12},{36,34},{48,46},{54,52},{54,50},{54,36},{52,22},{54,6},{56,
              0},{56,-2},{50,-6},{40,-16},{28,-34},{18,-54},{6,-74},{0,-90},{-2,
              -84},{-12,-68},{-26,-50},{-38,-40},{-42,-38},{-36,-34},{-24,-22},{
              -14,-12}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(false,if passedAll then true else false)),
        Polygon(
          points={{-38,-4},{-48,-14},{-10,-42},{-48,-70},{-38,-80},{0,-52},{38,-80},
              {48,-70},{10,-42},{48,-14},{36,-4},{0,-32},{-38,-4}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(false,if not passedAll then true else false))}),
  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BoundaryCheck;
