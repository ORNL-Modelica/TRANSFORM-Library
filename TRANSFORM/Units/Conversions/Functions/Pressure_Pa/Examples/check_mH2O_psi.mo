within TRANSFORM.Units.Conversions.Functions.Pressure_Pa.Examples;
model check_mH2O_psi
  extends TRANSFORM.Icons.Example;
  parameter SI.Length u=1;
  final parameter Real x_reference[unitTests.n]={1/0.703070,0.703070};
  Real x[unitTests.n];
  Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  x[1] =from_mH2O_to_psi(u);
  x[2] =from_psi_to_mH2O(u);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_mH2O_psi;
