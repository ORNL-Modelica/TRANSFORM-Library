within TRANSFORM.Utilities.CharacteristicNumbers.Examples;
model Verification
  extends TRANSFORM.Icons.Example;

  constant Integer nNumbers = 1;

  Units.NonDim[nNumbers] Answer;
  Units.NonDim[nNumbers] CharNumber;

  ErrorAnalysis.Errors_AbsRelRMSold summary_Error(
    n=nNumbers,
    x_1=CharNumber,
    x_2=Answer) annotation (Placement(transformation(extent={{60,60},{80,80}})));

equation

  CharNumber[1] = JakobNumber(4193, 50, 100, 2257e3);
  Answer[1] = 0.0928887904;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=100));
end Verification;
