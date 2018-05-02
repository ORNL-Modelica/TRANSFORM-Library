within TRANSFORM.Math.Examples;
model spliceTanh

  extends TRANSFORM.Icons.Example;

  Real y "Function value";
  Utilities.ErrorAnalysis.UnitTests unitTests(x={y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  y =TRANSFORM.Math.spliceTanh(
    pos=1,
    neg=-1,
    x=time-5,
    deltax=1);
  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput);
end spliceTanh;
