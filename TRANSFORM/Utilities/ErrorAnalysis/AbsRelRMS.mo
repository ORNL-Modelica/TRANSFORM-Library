within TRANSFORM.Utilities.ErrorAnalysis;
function AbsRelRMS
  "Calculation of absolute, relative, and rms errors"

  extends Icons.Function;

input Real[:] x_1 "Values of interest" annotation(Dialog(group="Input Variables:"));
input Real[:] x_2 "Reference values" annotation(Dialog(group="Input Variables:"));
input Real errorExpected = 1e-6 "if Error_rms < errorExpected then test = Passed";
input Real tolerance = 100*Modelica.Constants.eps "To avoid division by 0";

output Real Error_rms "Root Mean Square error sqrt(sum(Error_abs.^2)/n)";
output Real Error_rmsRel "Root Mean Square error sqrt(sum(Error_rel.^2)/n)";
output Real[size(x_1,1)] Error_abs "Absolute error (x_1 - x_2)";
output Units.nonDim[size(x_1,1)] Error_rel "Relative error (x_1 - x_2)/x_2";
output Real passedTest "if 0 (false) then expected and actual values to not match within the expected error";

protected
  Integer n=size(x_1,1) "Size of variable array";
  Real[n] Error_absRaw "Absolute error not filtered by machine tolerance";
  Units.nonDim[n] Error_relRaw "Relative error not filtered by machine tolerance";

algorithm

  for i in 1:n loop
    Error_absRaw[i] :=x_1[i] - x_2[i];
    Error_abs[i] :=noEvent(if abs(Error_absRaw[i]) <= tolerance then 0 else
      Error_absRaw[i]);

    if abs(x_2[i]) <= tolerance then
      Error_relRaw[i] :=x_1[i];
    else
      Error_relRaw[i] :=Error_absRaw[i]/x_2[i];
    end if;
      Error_rel[i] :=noEvent(if abs(Error_relRaw[i]) <= tolerance then 0 else
      Error_relRaw[i]);
  end for;

  Error_rms :=sqrt(sum(Error_abs .^ 2)/n);
  Error_rmsRel :=sqrt(sum(Error_rel .^ 2)/n);

  passedTest:=if Error_rms < errorExpected then 1 else 0;

  annotation (defaultComponentName="summary_Error",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-102,136},{102,110}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}),                     Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Note: If abs(x_2[i]) &LT;= eps then the relative error is simply x_1[i].</p>
</html>"));
end AbsRelRMS;
