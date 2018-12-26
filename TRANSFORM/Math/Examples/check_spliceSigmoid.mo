within TRANSFORM.Math.Examples;
model check_spliceSigmoid
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;

  Real y "Function value";
  Real dy, dy2, dy3,dy4 "Test der";

  Real y1 "Sigmoid value";

  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=3, x={y,dy,y1})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  y =TRANSFORM.Math.spliceSigmoid(
    neg=-1,
    pos=1,
    x=time-5,
    k=10);

    dy = der(y);
    dy2 = der(dy);
    dy3 = der(dy2);
    dy4 = der(dy3);

  y1 = TRANSFORM.Math.sigmoid(time, 5, 10);

  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput);
end check_spliceSigmoid;
