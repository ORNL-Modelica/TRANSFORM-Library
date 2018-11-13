within TRANSFORM.Math.Examples;
model spliceCosN
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;

  Real y "Function value";
  Real dy, dy2, dy3,dy4;

  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(x={y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  y =TRANSFORM.Math.spliceCosN(
    pos=1,
    neg=-1,
    x=time-5,
    deltax=1);
    dy = der(y);
    dy2 = der(dy);
    dy3 = der(dy2);
    dy4 = der(dy3);

  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput);
end spliceCosN;
