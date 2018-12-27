within TRANSFORM.Math.Examples;
model check_smoothMax

  extends TRANSFORM.Icons.Example;

  Real y "Function value";
  Real dy,dy2 "Test der";

  Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={y,dy})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  y =TRANSFORM.Math.smoothMax(
    x1=10,
    x2=time,
    dx=5);

  dy = der(y);
  dy2 = der(dy);
  annotation (experiment(StopTime=20),__Dymola_experimentSetupOutput);
end check_smoothMax;
