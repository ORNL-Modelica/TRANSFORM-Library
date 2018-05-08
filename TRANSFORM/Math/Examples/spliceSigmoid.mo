within TRANSFORM.Math.Examples;
model spliceSigmoid
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;

  Real y "Function value";
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(x={y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  y =TRANSFORM.Math.spliceSigmoid(
    below=-1,
    above=1,
    x=time,
    x0=5,
    k=1000);
  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput);
end spliceSigmoid;
