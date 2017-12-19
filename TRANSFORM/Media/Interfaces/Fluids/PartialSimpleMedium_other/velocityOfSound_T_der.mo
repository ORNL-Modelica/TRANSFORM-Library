within TRANSFORM.Media.Interfaces.Fluids.PartialSimpleMedium_other;
function velocityOfSound_T_der
  input Temperature T "Temperature";
  input Real der_T;
  output Real der_a;
algorithm
  der_a := a_T_coef[1];
  annotation (Inline=true);
end velocityOfSound_T_der;
