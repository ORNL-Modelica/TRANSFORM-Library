within TRANSFORM.Units.Conversions.Functions.Examples;
model check_SpecificEnergy_J_kg
  extends TRANSFORM.Icons.Example;

  parameter SI.Length u=1;

  final parameter Real x_reference[unitTests.n]={1,1};

  Real x[unitTests.n];

  Utilities.ErrorAnalysis.UnitTests unitTests(
    n=6,
    x=x,
    x_reference=x_reference)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation

  x[1] = Energy_J.to_J_kg(u);
  x[2] = Energy_J.from_J_kg(u);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_SpecificEnergy_J_kg;
