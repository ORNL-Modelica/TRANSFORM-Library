within TRANSFORM.Math.Examples;
model logspace

  extends TRANSFORM.Icons.Example;

  parameter Integer n=10;

  Real[n] y "Function value";
  Real[n-1] dy "Difference betwee y values";
  Utilities.ErrorAnalysis.UnitTests unitTests(x=y, n=n)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  (y,dy) =TRANSFORM.Math.logspace(
    start=1,
    stop=100,
    n=n);
  annotation (experiment(__Dymola_NumberOfIntervals=100),
                                      __Dymola_experimentSetupOutput);
end logspace;
