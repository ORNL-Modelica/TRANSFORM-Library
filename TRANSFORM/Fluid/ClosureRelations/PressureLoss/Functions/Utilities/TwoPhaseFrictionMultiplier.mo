within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Utilities;
function TwoPhaseFrictionMultiplier

  //phi^2_fo: tw-phase fritional multiplier based on signle phase friction for the homogenous model steam-water system
  // Source: Collier and Thome, Convective Boiling and Condensation, 3E, Table 2-1, pg. 46

  input SIadd.NonDim x_abs "Absolute quality";
  input SI.DynamicViscosity mu_lsat "Liquid dynamic viscosity";
  input SI.DynamicViscosity mu_vsat "Vapor dynamic viscosity";
  input SI.Density rho_lsat "Liquid density";
  input SI.Density rho_vsat "Vapor density";

  output Real phi2 "Two-phase modifier";
algorithm

  phi2 := (1+x_abs*(rho_lsat*(1/rho_vsat-1/rho_lsat)))*(1+x_abs*((mu_lsat-mu_vsat)/mu_vsat))^(-0.25);

annotation(Inline=true);
end TwoPhaseFrictionMultiplier;
