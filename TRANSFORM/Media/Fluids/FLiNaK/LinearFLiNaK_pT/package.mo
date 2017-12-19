within TRANSFORM.Media.Fluids.FLiNaK;
package LinearFLiNaK_pT "FLiNaK | LiF-NaF-KF 46.5%-11.5%-42% | Linear compressibility"

// beta_const adjusted till density matched. kappa left alone
// references are based on 800K
// assumed specific enthalpy at 273.15 is zero
  extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
    mediumName="Linear FLiNaK",
    constantJacobian=false,
    reference_p=1e5,
    reference_T=800,
    reference_d=Utilities.d_T(reference_T),
    reference_h=Utilities.cp_T(reference_T)*(reference_T-273.15),
    reference_s=0,
    beta_const=3.40327e-4,
    kappa_const=2.89e-10,
    cp_const=Utilities.cp_T(reference_T),
    MM_const=0.0413,
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
end LinearFLiNaK_pT;
