within TRANSFORM.Math.Examples;
model check_isMonotonic

  extends TRANSFORM.Icons.Example;

  parameter Real x1[11] = cat(1,linspace(0,5,6),linspace(5,9,5));
  parameter Real x2[11] = cat(1,linspace(0,5,6),linspace(5,1,5));
  parameter Boolean strict=false "Set to true to test for strict monotonicity";
  Boolean y1,y2,y3,y4;

  Utilities.ErrorAnalysis.UnitTests unitTests(n=4,x={if y1 then 1 else 0,if y2 then 1 else 0,if y3 then 1 else 0,if y4 then 1 else 0})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

equation
  y1 = isMonotonic(x1,strict);
  y2 = isMonotonic(x1,not strict);
  y3 = isMonotonic(x2,strict);
  y4 = isMonotonic(x2,not strict);

  annotation (experiment(StopTime=10), Documentation(info="<html>
</html>"));
end check_isMonotonic;
