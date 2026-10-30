within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers.Examples;
model check_pico
  extends TRANSFORM.Icons.Example;
  parameter SI.Length u=1;
  final parameter Real x_reference[unitTests.n]={1e12,1e-12};
  Real x[unitTests.n];
  Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  x[1] = to_pico(u);
  x[2] = from_pico(u);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_pico;
