within TRANSFORM.Units.Conversions.Functions.MassFlowRate_kg_s.Examples;
model check_lbm_hr
  extends TRANSFORM.Icons.Example;
  parameter SI.Length u=1;
  final parameter Real x_reference[unitTests.n]={2.20462*60*60,1/2.20462/60/60};
  Real x[unitTests.n];
  Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  x[1] = to_lbm_hr(u);
  x[2] = from_lbm_hr(u);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_lbm_hr;
