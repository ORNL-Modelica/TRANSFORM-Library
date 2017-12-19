within TRANSFORM.Media.Interfaces.Fluids.PartialSimpleMedium_other;
function thermalConductivity_T_der
  input Temperature T "Temperature";
  input Real der_T;
  output Real der_lambda;
algorithm
  der_lambda := lambda_T_coef[1];
  annotation (Inline=true);
end thermalConductivity_T_der;
