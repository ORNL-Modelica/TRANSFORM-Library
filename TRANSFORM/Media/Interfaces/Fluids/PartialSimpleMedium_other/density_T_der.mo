within TRANSFORM.Media.Interfaces.Fluids.PartialSimpleMedium_other;
function density_T_der
  input Temperature T "Temperature";
  input Real der_T;
  output Real der_d;
algorithm
  der_d := d_T_coef[1];
  annotation (Inline=true);
end density_T_der;
