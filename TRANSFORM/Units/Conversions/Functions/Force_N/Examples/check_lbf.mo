within TRANSFORM.Units.Conversions.Functions.Force_N.Examples;
model check_lbf
  extends TRANSFORM.Icons.Example;
  parameter SI.Force u=1;
  final parameter Real x_reference[unitTests.n]={2.20462/Modelica.Constants.g_n,Modelica.Constants.g_n/2.20462};
  //  ,1/1.60218e-13,1.60218e-13}
  Real x[unitTests.n];
  Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  x[1] = to_lbf(u);
  x[2] = from_lbf(u);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_lbf;
