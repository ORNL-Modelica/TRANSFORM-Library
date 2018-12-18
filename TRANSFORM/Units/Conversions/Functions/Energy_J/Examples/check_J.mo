within TRANSFORM.Units.Conversions.Functions.Energy_J.Examples;
model check_J

  extends TRANSFORM.Icons.Example;

  parameter SI.Length u=1;

  final parameter Real x_reference[unitTests.n]={1,1};

  Real x[unitTests.n];

  Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation

  x[1] = to_J(u);
  x[2] = from_J(u);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_J;
