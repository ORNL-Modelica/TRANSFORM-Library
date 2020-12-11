within TRANSFORM.Math.Examples;
model check_spliceTanh
  extends TRANSFORM.Icons.Example;
  Real y "Function value";
  Real dy "Test der";
  Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={y,dy})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  y =TRANSFORM.Math.spliceTanh(
    pos=1,
    neg=-1,
    x=time-5,
    deltax=1);
    dy = der(y);
  annotation (experiment(StopTime=10));
end check_spliceTanh;
