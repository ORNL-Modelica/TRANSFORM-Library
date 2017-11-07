within TRANSFORM.Math.Examples;
model logspace

  extends Modelica.Icons.Example;

  parameter Integer n=10;

  Real[n] y "Function value";
  Real[n-1] dy "Difference betwee y values";
equation
  (y,dy) =TRANSFORM.Math.logspace(
    start=1,
    stop=100,
    n=n);
  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput);
end logspace;
