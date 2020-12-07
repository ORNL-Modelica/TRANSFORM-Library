within TRANSFORM.Utilities.Diagnostics.BaseClasses;
block PartialInputCheck "Assert when condition is violated"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Time startTime=0
    "Start time for activating the assert";
  parameter Real threshold(min=0) = 1E-2
    "Threshold for equality comparison";
  parameter String message = "Inputs differ by more than threShold";
  Modelica.Blocks.Interfaces.RealInput u1 "Value to check"
       annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput u2 "Value to check"
       annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
protected
  parameter Modelica.Units.SI.Time t0(fixed=false) "Simulation start time";
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
