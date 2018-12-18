within TRANSFORM.Units.Conversions.Functions.TemperatureDifference_dK.Examples;
model check_degForR_diff

  extends TRANSFORM.Icons.Example;

  parameter SI.Length u=1;

  final parameter Real x_reference[unitTests.n]={1.8,1/1.8};

  Real x[unitTests.n];

  Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation

  x[1] =to_degForR_diff(u);
  x[2] =from_degForR_diff(u);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_degForR_diff;
