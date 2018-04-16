within TRANSFORM.Utilities.ErrorAnalysis;
model UnitTests
  "Calculation of absolute, relative, and rms errors. Model is looked for in examples to identify variables included in regression unit tests as well."

  parameter Integer n=1 "Array size of x and x_reference";

  input Real x[n] "Variables of interest"
    annotation (Dialog(group="Inputs"));
  input Real x_reference[n]=fill(0, n) "Reference values"
    annotation (Dialog(group="Inputs"));

  parameter Boolean errorCalcs=false
    "=true to perform error calculations of x vs x_reference"
    annotation (Dialog(group="Parameters: Error Calculation"), Evalute=true);
  parameter Real errorExpected=1e-6
    "if Error_rms < errorExpected then test = Passed" annotation (Dialog(group="Parameters: Error Calculation",
        enable=errorCalcs));
  parameter Real tolerance=100*Modelica.Constants.eps
    "eps = tolerance*MachineError to avoid division by 0" annotation (Dialog(
        group="Parameters: Error Calculation", enable=errorCalcs));
  parameter Boolean printResult=false "Save success/fail result to file"
    annotation (Dialog(group="Parameters: Error Calculation", enable=errorCalcs),
      Evalute=true);
  parameter String name="" "Name of example for log file identification"
    annotation (Dialog(group="Parameters: Error Calculation", enable=
          printResult and errorCalcs));

  Real Error_rms "Root Mean Square error sqrt(sum(Error_abs.^2)/n)";
  Real Error_rmsRel "Root Mean Square error sqrt(sum(Error_rel.^2)/n)";
  Real[n] Error_abs "Absolute error (x - x_reference)";
  Units.NonDim[n] Error_rel "Relative error (x - x_reference)/x_reference";
  Boolean allPassed(start=true)
    "=true if x = x_reference for all times within tolerance";

protected
  Real passedTest(start=0) "if 0 (false) then x and x_reference are not equal";
equation

  if errorCalcs then
    (Error_rms,Error_rmsRel,Error_abs,Error_rel,passedTest) =
      TRANSFORM.Utilities.ErrorAnalysis.AbsRelRMS(
      x,
      x_reference,
      errorExpected,
      tolerance);
  else
    Error_rms = Modelica.Constants.inf;
    Error_rmsRel = Modelica.Constants.inf;
    Error_abs = fill(Modelica.Constants.inf, n);
    Error_rel = fill(Modelica.Constants.inf, n);
    passedTest = 2;
  end if;

  when passedTest < 1 then
    allPassed = false;
  end when;

  if printResult then
    when terminal() then
      Modelica.Utilities.Streams.print(String(allPassed) + " | " + name, "unitTest_results.txt");
    end when;
  end if;

          // fillColor=DynamicSelect({255,255,255}, if not errorCals then {222,222,0} else (if allPassed
          //      then {0,191,0} else {255,61,44})),

  annotation (
    defaultComponentName="unitTests",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor=DynamicSelect({255,255,255}, if not errorCalcs then {222,222,0} else (if allPassed
               then {0,191,0} else {255,61,44})),
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
          textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Note: If abs(x_reference[i]) &LT;= tolerance then the relative error is simply x[i].</p>
</html>"));
end UnitTests;
