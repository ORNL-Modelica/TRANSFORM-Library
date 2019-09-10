within TRANSFORM.Math.Scratch;
model check_spliceTanh_Derivatives
  extends TRANSFORM.Icons.Example;
  Real y,y2;
  Real dy,dy2;

  Real func1;
  Real func2;

  Real m = 5;
  Real b = -5;

  Real aa = -0.5;
  Real bb = 2;
  Real cc = -0.5;

  Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={y,dy})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

initial equation
  y = func1;
  y2 = func1;
equation

  func1 = m*(time-2)+b;

  func2 = aa*time^2 + bb*time + cc;

  der(y) = dy;

  dy =TRANSFORM.Math.spliceTanh(
    pos=der(func2),
    neg=der(func1),
    x=time-3,
    deltax=1);

der(y2) = dy2;
dy2=TRANSFORM.Math.Scratch.splicetests(
    pos=der(func2),
    neg=der(func1),
    x=time - 3,
    deltax=2,
    curvature=0.021);

  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Possible method for smoothing transitioning between two crossing curves.</p>
</html>"));
end check_spliceTanh_Derivatives;
