within TRANSFORM.Utilities.ErrorAnalysis;
model Errors_AbsRelRMSold "Calculation of absolute, relative, and rms errors"
  extends TRANSFORM.Icons.ObsoleteModel;
parameter Integer n "Length of variable vector";
parameter Real errorExpected = 1e-6 "if Error_rms < errorExpected then test = Passed";
parameter Real tolerance = 100 "eps = tolerance*MachineError to avoid division by 0";
input Real[n] x_1 "Values of first variable" annotation(Dialog(group="Inputs"));
input Real[n] x_2 "Values of second variable" annotation(Dialog(group="Inputs"));
Boolean passedTest "if false then expected and actual values to not match within the expected error";
Real Error_rms "Root Mean Square error sqrt(sum(Error_abs.^2)/n)";
Real[n] Error_abs "Absolute error (x_1 - x_2)";
Units.NonDim[n] Error_rel "Relative error (x_1 - x_2)/x_2";
protected
  Real eps = Modelica.Constants.eps*tolerance;
  Real[n] Error_absRaw "Absolute error not filtered by machine tolerance";
  Units.NonDim[n] Error_relRaw "Relative error not filtered by machine tolerance";
equation
  for i in 1:n loop
    Error_absRaw[i] = x_1[i] - x_2[i];
    Error_abs[i] = noEvent(if abs(Error_absRaw[i]) <= eps then 0 else
      Error_absRaw[i]);
    if abs(x_2[i]) <= eps then
      Error_relRaw[i] = x_1[i];
    else
      Error_relRaw[i] = Error_absRaw[i]/x_2[i];
    end if;
      Error_rel[i] = noEvent(if abs(Error_relRaw[i]) <= eps then 0 else
      Error_relRaw[i]);
  end for;
  Error_rms = sqrt(sum(Error_abs .^ 2)/n);
  passedTest=if Error_rms < errorExpected then true else false;
  annotation (defaultComponentName="summary_Error",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-51,-40},{-48,60}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-1,-49.5},{1,49.5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={0.5,-39},
          rotation=-90,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-33,-6},{-29,-10}},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-33,-12},{-29,-16}},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-21,10},{-17,6}},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{1,12},{5,8}},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{21,20},{25,16}},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-21,4},{-17,0}},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{1,8},{5,4}},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{23,18},{27,14}},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Line(
          points={{-48,-38},{-30,-24},{-18,-32},{4,-36},{26,-38}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Text(
          extent={{-102,136},{102,110}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}),                     Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Note: If abs(x_2[i]) &LT;= eps then the relative error is simply x_1[i].</p>
<p><br>This model is obsolete because it has some issue with a passedTest varaible regardless of if its boolean or real depending on the errorExpected value.</p>
<p>Moved to a function to remove issue.</p>
</html>"));
end Errors_AbsRelRMSold;
