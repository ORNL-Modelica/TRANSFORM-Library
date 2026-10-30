within TRANSFORM.Media.Interfaces.Fluids.PartialSimpleMedium_other;
function dynamicViscosity_T_der
  input Temperature T "Temperature";
  input Real der_T;
  output Real der_eta;
algorithm
  der_eta := eta_T_coef[1];
  annotation (Inline=true);
end dynamicViscosity_T_der;
