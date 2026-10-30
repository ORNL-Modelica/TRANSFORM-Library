within TRANSFORM.Units.Conversions.Functions.Pressure_Pa.Examples;
model check_bar
  extends TRANSFORM.Icons.Example;
  parameter SI.Length u=1;
  final parameter Real x_reference[unitTests.n]={1e-5,1e5};
  Real x[unitTests.n];
  Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  x[1] = to_bar(u);
  x[2] = from_bar(u);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_bar;
