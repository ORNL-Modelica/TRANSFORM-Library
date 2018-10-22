within TRANSFORM.Math.Examples;
model spliceCosN
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;

  Real y "Function value";

  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(x={y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  y =TRANSFORM.Math.spliceCosN(
    below=1,
    above=-1,
    x=time-5,
    deltax=1);

  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput);
end spliceCosN;
