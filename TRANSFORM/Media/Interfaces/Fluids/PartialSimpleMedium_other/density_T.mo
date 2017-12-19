within TRANSFORM.Media.Interfaces.Fluids.PartialSimpleMedium_other;
function density_T
  input Temperature T "Temperature";
  output Density d "Density";
algorithm
  d := d_T_coef[1]*T + d_T_coef[2];
  annotation (Inline=true, derivative=density_T_der);
end density_T;
