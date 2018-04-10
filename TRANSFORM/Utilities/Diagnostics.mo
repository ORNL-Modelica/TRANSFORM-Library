within TRANSFORM.Utilities;
package Diagnostics "Models to diagnose model errors"

  package Examples
    extends TRANSFORM.Icons.ExamplesPackage;

    model CheckEquality
      extends Modelica.Icons.Example;

      TRANSFORM.Utilities.Diagnostics.CheckEquality check
        annotation (Placement(transformation(extent={{20,-4},{40,16}})));
      Modelica.Blocks.Sources.Constant con(k=0.1) "Input"
        annotation (Placement(transformation(extent={{-60,16},{-40,36}})));
      Modelica.Blocks.Sources.Sine sin1(freqHz=1, amplitude=0.03)
        "Input"
        annotation (Placement(transformation(extent={{-60,-24},{-40,-4}})));
      Modelica.Blocks.Math.Add add "Adder to offset the sin input signal"
        annotation (Placement(transformation(extent={{-20,-14},{0,6}})));
      ErrorAnalysis.UnitTests unitTests(x={check.y})
        annotation (Placement(transformation(extent={{80,80},{100,100}})));
    equation

      connect(con.y, check.u1) annotation (Line(points={{-39,26},{-20,26},{-20,
              12},{18,12}}, color={0,0,127}));
      connect(add.u1, con.y) annotation (Line(points={{-22,2},{-30,2},{-30,26},
              {-39,26}},
                    color={0,0,127}));
      connect(sin1.y, add.u2) annotation (Line(points={{-39,-14},{-30,-14},{-30,
              -10},{-22,-10}},
                   color={0,0,127}));
      connect(add.y, check.u2) annotation (Line(points={{1,-4},{10,-4},{10,0},{
              18,0}}, color={0,0,127}));
      annotation (Documentation(
        info="",
    revisions="<html>
</html>"),
        experiment(Tolerance=1e-6, StopTime=1));
    end CheckEquality;
  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains models that validate the diagnostics models.
These model outputs are stored as reference data to
allow continuous validation whenever models in the library change.
</p>
</html>"));
  end Examples;

  block AssertEquality "Assert when condition is violated"
    extends BaseClasses.PartialInputCheck(message = "Inputs differ by more than threshold");
  equation
    if noEvent(time > t0) then
      assert(noEvent(abs(u1 - u2) < threshold), message + "\n"
        + "  time       = " + String(time) + "\n"
        + "  u1         = " + String(u1) + "\n"
        + "  u2         = " + String(u2) + "\n"
        + "  abs(u1-u2) = " + String(abs(u1-u2)) + "\n"
        + "  threshold  = " + String(threshold));
    end if;
  annotation (
  defaultComponentName="check",
  Documentation(info="<html>
<p>Model that triggers an assert if <i>|u1-u2| &gt; threshold</i> and <i>t &gt; t<sub>0</i></sub>. </p>
</html>",
  revisions="<html>
</html>"),
      Icon(graphics={
                 Text(
            extent={{-100,20},{100,-20}},
            lineColor={0,0,0},
            textString="u1 = u2 ?")}));
  end AssertEquality;

  block AssertInequality "Assert when condition is violated"
    extends BaseClasses.PartialInputCheck(message = "Inputs differ by more than threshold",
       threshold = 0);
  equation
    if noEvent(time > t0) then
      assert(noEvent(u1 > u2 -threshold),  message + "\n"
        + "  time       = " + String(time) + "\n"
        + "  u1         = " + String(u1) + "\n"
        + "  u2         = " + String(u2) + "\n"
        + "  abs(u1-u2) = " + String(abs(u1-u2)) + "\n"
        + "  threshold  = " + String(threshold));
    end if;
  annotation (
  defaultComponentName="check",
  Documentation(
  info="<html>
<p>
Model that triggers an assert if
<i>u1 &gt; u2 - threShold</i>
and <i>t &gt; t<sub>0</sub></i>.
</p>
</html>",
  revisions="<html>
</html>"),
      Icon(graphics={
                 Text(
            extent={{-100,20},{100,-20}},
            lineColor={0,0,0},
            textString="u1 > u2 ?")}));
  end AssertInequality;

  block CheckEquality "Check equality between inputs up to a threshold"
    extends Modelica.Blocks.Icons.Block;

    parameter Real threshold(min=0) = 1e-2 "Threshold for equality comparison";

    Modelica.Blocks.Interfaces.RealInput u1 "Value to check"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
    Modelica.Blocks.Interfaces.RealInput u2 "Value to check"
      annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
    Modelica.Blocks.Interfaces.RealOutput y "Error"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  equation
    y = noEvent(if abs(u2-u1)<threshold  then 0 else u2-u1);

  annotation (
  defaultComponentName="check",
  Documentation(info="<html>
<p>Block that outputs <i>0</i> if the difference <i>|u1-u2| &lt; threshold</i>, or else it outputs <i>u2-u1</i>. </p>
</html>",
  revisions="<html>
</html>"),
      Icon(graphics={
          Text(
            extent={{-62,-38},{54,-68}},
            lineColor={0,0,255},
            textString="%threshold"),
                 Text(
            extent={{-100,20},{100,-20}},
            lineColor={0,0,0},
            textString="u1 = u2 ?")}));
  end CheckEquality;

  package BaseClasses
    extends Modelica.Icons.BasesPackage;

    block PartialInputCheck "Assert when condition is violated"
      extends Modelica.Blocks.Icons.Block;
      parameter Modelica.SIunits.Time startTime = 0
        "Start time for activating the assert";
      parameter Real threshold(min=0) = 1E-2
        "Threshold for equality comparison";
      parameter String message = "Inputs differ by more than threShold";
      Modelica.Blocks.Interfaces.RealInput u1 "Value to check"
           annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
      Modelica.Blocks.Interfaces.RealInput u2 "Value to check"
           annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
    protected
      parameter Modelica.SIunits.Time t0( fixed=false) "Simulation start time";
    initial equation
      t0 = time + startTime;

      annotation (Icon(graphics={Text(
              extent={{-62,-54},{54,-84}},
              lineColor={162,29,33},
              textString="%threshold")}),
    Documentation(info="<html>
<p>
Partial model that can be used to check whether its
inputs satisfy a certain condition such as equality within
a prescribed threshold.
</p>
</html>"));
    end PartialInputCheck;
  end BaseClasses;
annotation (preferredView="info", Documentation(info="<html>
<p>This package contains component models for run-time diagnostics.</p>
<p>The models in this package can be used to stop a simulation if a test is violated. </p>
</html>"));
end Diagnostics;
