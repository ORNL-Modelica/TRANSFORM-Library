within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Utilities;
function TwoPhaseFrictionMultiplier

  input SIadd.NonDim x_abs "Absolute quality";
  input SI.DynamicViscosity mu_l "Liquid dynamic viscosity";
  input SI.DynamicViscosity mu_v "Vapor dynamic viscosity";
  input SI.Density rho_l "Liquid density";
  input SI.Density rho_v "Vapor density";

  output Real phi2 "Two-phase modifier";
algorithm

  phi2 := (1+x_abs*(rho_l*(1/rho_v-1/rho_l)))*(1+x_abs*((mu_l-mu_v)/mu_v))^(-0.25);

annotation(Inline=true);
end TwoPhaseFrictionMultiplier;
