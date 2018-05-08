within TRANSFORM.Math.Examples;
model smoothMax

  extends TRANSFORM.Icons.Example;

  Real y "Function value";
  Utilities.ErrorAnalysis.UnitTests unitTests(x={y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  y =TRANSFORM.Math.smoothMax(
    x1=0,
    x2=time,
    dx=5);
  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput);
end smoothMax;
