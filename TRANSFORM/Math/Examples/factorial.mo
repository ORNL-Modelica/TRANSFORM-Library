within TRANSFORM.Math.Examples;
model factorial

  extends TRANSFORM.Icons.Example;

  final parameter Integer n=8;
  final parameter Real ExactValue=8*7*6*5*4*3*2*1;

  Real y "Function value";

  Utilities.ErrorAnalysis.UnitTests unitTests(x={y}, x_reference={
        ExactValue})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation

  y = TRANSFORM.Math.factorial(n);

  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput);
end factorial;
