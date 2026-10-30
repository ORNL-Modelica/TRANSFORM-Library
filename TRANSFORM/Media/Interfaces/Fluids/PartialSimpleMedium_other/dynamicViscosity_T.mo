within TRANSFORM.Media.Interfaces.Fluids.PartialSimpleMedium_other;
function dynamicViscosity_T
  input Temperature T "Temperature";
  output DynamicViscosity eta "Dynamic viscosity";
algorithm
  eta := eta_T_coef[1]*T + eta_T_coef[2];
  annotation (Inline=true, derivative=dynamicViscosity_T_der);
end dynamicViscosity_T;
