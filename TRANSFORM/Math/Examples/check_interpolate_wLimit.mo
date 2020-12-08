within TRANSFORM.Math.Examples;
model check_interpolate_wLimit
  extends TRANSFORM.Icons.Example;
  parameter Real[5] x = {0,1,2,3,4};
  parameter Real[5] y = {-1,3,5,6,2};
  Real y_int;
 Utilities.ErrorAnalysis.UnitTests unitTests(x={y_int})
   annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.Sine xi(amplitude=10, f=1/10)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  y_int = interpolate_wLimit(x, y, xi.y, 1, true)
  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput);
  annotation (experiment(StopTime=10));
end check_interpolate_wLimit;
