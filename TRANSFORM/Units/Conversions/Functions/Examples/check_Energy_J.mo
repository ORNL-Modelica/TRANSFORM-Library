within TRANSFORM.Units.Conversions.Functions.Examples;
model check_Energy_J
  extends TRANSFORM.Icons.Example;

  parameter SI.Length u=1;

  final parameter Real x_reference[unitTests.n]={1,1,1/1055.06,1055.06,1/1.60218e-13,1.60218e-13};

  Real x[unitTests.n];

  Utilities.ErrorAnalysis.UnitTests unitTests(
    n=6,
    x=x,
    x_reference=x_reference)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation

  x[1] = Energy_J.to_J(u);
  x[2] = Energy_J.from_J(u);
  x[3] = Energy_J.to_btu(u);
  x[4] = Energy_J.from_btu(u);
  x[5] = Energy_J.to_MeV(u);
  x[6] = Energy_J.from_MeV(u);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_Energy_J;
