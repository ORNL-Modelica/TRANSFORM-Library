within TRANSFORM.Math.Examples;
model check_logspace
  extends TRANSFORM.Icons.Example;
  parameter Integer n=10;
  Real[n] y "Function value";
  Real[n-1] dy "Difference betwee y values";
  Utilities.ErrorAnalysis.UnitTests unitTests(x=y, n=10)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  (y,dy) =TRANSFORM.Math.logspace(
    start=1,
    stop=10,
    n=n);
  annotation (experiment(__Dymola_NumberOfIntervals=100),
                                      __Dymola_experimentSetupOutput);
end check_logspace;
