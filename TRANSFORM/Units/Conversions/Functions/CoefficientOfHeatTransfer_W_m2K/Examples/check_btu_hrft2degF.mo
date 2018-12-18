within TRANSFORM.Units.Conversions.Functions.CoefficientOfHeatTransfer_W_m2K.Examples;
model check_btu_hrft2degF

  extends TRANSFORM.Icons.Example;

  parameter SI.Length u=1;

  final parameter Real x_reference[unitTests.n]={0.17677,1/0.17677};

  Real x[unitTests.n];

  Utilities.ErrorAnalysis.UnitTests unitTests(n=2,x=x, x_reference=x_reference)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation

  x[1] =to_btu_hrft2degF(u);
  x[2] =from_btu_hrft2degF(u);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_btu_hrft2degF;
