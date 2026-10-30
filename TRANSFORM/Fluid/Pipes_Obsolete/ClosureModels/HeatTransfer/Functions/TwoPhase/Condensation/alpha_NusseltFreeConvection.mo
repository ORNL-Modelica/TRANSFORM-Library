within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.HeatTransfer.Functions.TwoPhase.Condensation;
function alpha_NusseltFreeConvection
  //Constants
  input SI.Length L_c "Characteristic length";
  // Variables
  input SI.ThermalConductivity lambda "Fluid thermal conductivity";
  input SI.Density rho_fsat "Saturated liquid density";
  input SI.DynamicViscosity mu_fsat "Liquid dynamic viscosity";
  input SI.ThermalConductivity lambda_fsat "Liquid thermal conductivity";
  input SI.SpecificHeatCapacity cp_fsat
    "Liquid constant pressure heat capacity";
  input SI.Density rho_gsat "Vapour density";
  input SI.DynamicViscosity mu_gsat "Vapour dynamic viscosity";
  input SI.SpecificEnthalpy h_fg "Latent heat of vaporization";
  input SI.Temperature Ts "Fluid state temperature";
  input SI.Temperature Tsat "Fluid saturation temperature";
  input SI.Temperature Twall "Wall temperature";
  output SI.CoefficientOfHeatTransfer alpha
    "Two-phase total heat transfer coefficient";
  output SI.NusseltNumber Nu "Nusselt number";
  output SI.SpecificEnthalpy h_fgp "Modified latent heat of vaporization";
  output Units.NonDim Ja "Jakob number";
protected
  Units.NonDim Gr "Grashof number";
algorithm
  Gr :=Modelica.Constants.g_n*beta*(T_wall - T_inf)*L_c^3/nu^2;
  g_PR :=0.75*Pr^(0.5)/(0.609 + 1.221*Pr^(0.5) + 1.238*Pr)^(0.25);
  Nu :=4/3*(0.25*Gr_L)^(0.25)*g_PR;
  alpha :=Nu*lambda/L_c;
end alpha_NusseltFreeConvection;
