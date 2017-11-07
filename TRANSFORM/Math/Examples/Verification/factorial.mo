within TRANSFORM.Math.Examples.Verification;
model factorial

  extends Modelica.Icons.Example;

  Utilities.ErrorAnalysis.Errors_AbsRelRMSold summary_Error(
    n=1,
    x_1={y},
    x_2={ExactValue})
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  final parameter Integer n=8;
  final parameter Real ExactValue=8*7*6*5*4*3*2*1;

  Real y "Function value";

equation

  y = TRANSFORM.Math.factorial(n);

  annotation (experiment(StopTime=10),__Dymola_experimentSetupOutput);
end factorial;
