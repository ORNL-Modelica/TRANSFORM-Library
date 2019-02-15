within TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.TwoPhase.Condensation;
function alpha_NusseltTheory_Condensation
  "Nusselt Theory correlation for two-phase condensation"
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
  input SI.Temperature T_state "Fluid state temperature";
  input SI.Temperature T_sat "Fluid saturation temperature";
  input SI.Temperature T_wall "Wall temperature";
  output SI.CoefficientOfHeatTransfer alpha
    "Two-phase total heat transfer coefficient";
  output SI.NusseltNumber Nu "Nusselt number";
  output SI.SpecificEnthalpy h_fgp "Modified latent heat of vaporization";
  output Units.NonDim Ja "Jakob number";
algorithm
  Ja :=Utilities.CharacteristicNumbers.JakobNumber(
    cp_fsat,
    T_wall,
    T_sat,
    h_fg);
  h_fgp :=h_fg*(1 + 0.68*Ja);
  Nu := 0.943*(rho_fsat*Modelica.Constants.g_n*(rho_fsat - rho_gsat)*h_fgp*L_c^3/(
          mu_fsat*lambda_fsat*max(T_state - T_wall,0.001)))^(0.25);
  alpha :=Nu*lambda/L_c;
  annotation (Documentation(info="<html>
<p>Nusselt theory lumped condensation model.</p>
<p>Fundamentals of heat and mass transfer 6E Incropera and DeWitt.</p>
</html>"));
end alpha_NusseltTheory_Condensation;
