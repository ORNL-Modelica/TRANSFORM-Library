within TRANSFORM.Media.Fluids.Sodium;
package LinearSodium_pT "Sodium with linear compressibility"
// references are based on 800K
// specific enthalpy matches expected at 800K
  extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
    mediumName="Linear Sodium",
    constantJacobian=false,
    reference_p=1e5,
    reference_T=800,
    reference_d=Utilities.d_T(reference_T),
    reference_h=74.65e3+Utilities.cp_T(reference_T)*(reference_T-273.15),
    reference_s=0,
    beta_const=2.82e-4,
    kappa_const=2.89e-10,
    cp_const=Utilities.cp_T(reference_T),
    MM_const=0.02298976928,
    T_default = 800);

redeclare function extends dynamicViscosity "Dynamic viscosity"
algorithm
  eta := Utilities.eta_T(state.T);
  annotation(Inline=true);
end dynamicViscosity;

redeclare function extends thermalConductivity
    "Thermal conductivity"
algorithm
  lambda := Utilities.lambda_T(state.T);
  annotation(Inline=true);
end thermalConductivity;
end LinearSodium_pT;
