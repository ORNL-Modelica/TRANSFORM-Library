within TRANSFORM.Math.Examples;
model check_interpolate2D
  extends TRANSFORM.Icons.Example;
  parameter Real[5] x = {0,1,2,3,4};
  parameter Real[5] y = {0,1,2,3,4};
  parameter Real[5,5] z = {{1,2,6,3,8},{-1,-8,-6,6,8},{0.2,0.2,0.5,0.6,-0.8},{10,15,85,69,63},{166,666,22,15,356}};
  Real z_int;
 Utilities.ErrorAnalysis.UnitTests unitTests(x={z_int})
   annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.Sine xi(amplitude=10, freqHz=1/10)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Modelica.Blocks.Sources.Sine yi(amplitude=10, freqHz=1/10,
    phase=3.1415926535898)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
equation
  z_int = interpolate2D(x, y, z, xi.y, yi.y, true)
  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput);
  annotation (experiment(StopTime=10));
end check_interpolate2D;
