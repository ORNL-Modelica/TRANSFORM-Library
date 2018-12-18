within TRANSFORM.Units.Conversions.Functions.Examples;
model check_Distance_m
  extends TRANSFORM.Icons.Example;

  parameter SI.Length u=1;

  final parameter Real x_reference[unitTests.n]={1,1,100,0.01,1000,0.001,100/2.54,2.54/100,
      100/2.54/12,12*2.54/100,1e6,1e-6};

  Real x[unitTests.n];

  Utilities.ErrorAnalysis.UnitTests unitTests(
    n=12,
    x=x,
    x_reference=x_reference)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation

  x[1] = Distance_m.to_m(u);
  x[2] = Distance_m.from_m(u);
  x[3] = Distance_m.to_cm(u);
  x[4] = Distance_m.from_cm(u);
  x[5] = Distance_m.to_mm(u);
  x[6] = Distance_m.from_mm(u);
  x[7] = Distance_m.to_inch(u);
  x[8] = Distance_m.from_inch(u);
  x[9] = Distance_m.to_feet(u);
  x[10] = Distance_m.from_feet(u);
  x[11] = Distance_m.to_micron(u);
  x[12] = Distance_m.from_micron(u);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_Distance_m;
