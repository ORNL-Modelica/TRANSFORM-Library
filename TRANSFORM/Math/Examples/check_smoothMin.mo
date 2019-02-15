within TRANSFORM.Math.Examples;
model check_smoothMin
  extends TRANSFORM.Icons.Example;
  parameter Real x1=10;
  parameter Real dx=5;
  Real x2=time;
  Real y[4] "Function value";
  Real dy[4] "Test der";
  Utilities.ErrorAnalysis.UnitTests unitTests(n=4, x=y)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  for i in 1:4 loop
    if i == 1 then
      y[i] = smoothMin_splice(
        x1=x1,
        x2=x2,
        dx=dx);
    elseif i == 2 then
      y[i] = smoothMin_exponential(
        x1=x1,
        x2=x2,
        dx=dx);
    elseif i == 3 then
      y[i] = smoothMin_cubic(
        x1=x1,
        x2=x2,
        dx=dx);
    elseif i == 4 then
      y[i] = smoothMin_quadratic(
        x1=x1,
        x2=x2,
        dx=dx);
    end if;
    dy[i] = der(y[i]);
  end for;
  annotation (experiment(StopTime=20), __Dymola_experimentSetupOutput);
end check_smoothMin;
