within TRANSFORM.Media.Fluids.EthyleneGlycol;
package LinearEthyleneGlycol_50_Water "Ethylene_Glycol_50%Water by Mass | C2H6O2 | cp @ 20 C"
// beta_const adjusted till density matched. kappa left alone
// assumed specific enthalpy at 273.15 is zero
extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
  mediumName="Linear Ethylene Glycol",
  constantJacobian=false,
  reference_p=1e5,
  reference_T=20 + 273.15,
  reference_d=Utilities_EthyleneGlycol_50_Water.d_T(reference_T),
  reference_h=Utilities_EthyleneGlycol_50_Water.cp_T(reference_T)*(reference_T
       - 273.15),
  reference_s=0,
  beta_const=3.53e-4,
  kappa_const=2.89e-10,
  cp_const=Utilities_EthyleneGlycol_50_Water.cp_T(reference_T),
  MM_const=0.4,
  T_default=20 + 273.15);
    //Note: Kappa is useless
redeclare function extends dynamicViscosity "Dynamic viscosity"
algorithm
  eta :=Utilities_EthyleneGlycol_50_Water.eta_T(state.T);
  annotation(Inline=true);
end dynamicViscosity;

redeclare function extends thermalConductivity
    "Thermal conductivity"
algorithm
  lambda :=Utilities_EthyleneGlycol_50_Water.lambda_T(state.T);
  annotation(Inline=true);
end thermalConductivity;
end LinearEthyleneGlycol_50_Water;
