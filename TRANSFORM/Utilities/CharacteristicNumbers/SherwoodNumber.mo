within TRANSFORM.Utilities.CharacteristicNumbers;
function SherwoodNumber "Return Sherwood number"
  extends Modelica.Icons.Function;

  input Units.CoefficientOfMassTransfer alphaM "Coefficient of mass transfer";
  input SI.Length D "Characteristic dimension";
  input SI.DiffusionCoefficient D_ab "Mass diffusion coefficient";
  output Units.nonDim Sh "Sherwood number";
algorithm
  Sh := alphaM.*D./D_ab;
  annotation (Documentation(info="Nusselt number Nu = alpha*D/lambda"));
end SherwoodNumber;
