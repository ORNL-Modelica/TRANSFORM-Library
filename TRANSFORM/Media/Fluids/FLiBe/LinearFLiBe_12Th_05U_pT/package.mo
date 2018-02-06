within TRANSFORM.Media.Fluids.FLiBe;
package LinearFLiBe_12Th_05U_pT "FLiBe Fueled | LiF-BeF2-ThF4-UF4 71.5%-16%-12%-0.5% | Linear compressibility"

// beta_const adjusted till density matched. kappa left alone
// references are based on 800K
// assumed specific enthalpy at 273.15 is zero
  extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
    mediumName="Linear FLiBe",
    constantJacobian=false,
    reference_p=1e5,
    reference_T=800,
    reference_d=Utilities_12Th_05U.d_T(reference_T),
    reference_h=Utilities_12Th_05U.cp_T(reference_T)*(reference_T-273.15),
    reference_s=0,
    beta_const=1.964787e-4,
    kappa_const=2.89e-10,
    cp_const=Utilities_12Th_05U.cp_T(reference_T),
    MM_const=0.033,
    T_default = 800);

redeclare function extends dynamicViscosity "Dynamic viscosity"

algorithm
  eta := Utilities_12Th_05U.eta_T(state.T);
  annotation(Inline=true);
end dynamicViscosity;

redeclare function extends thermalConductivity
    "Thermal conductivity"
algorithm
  lambda := Utilities_12Th_05U.lambda_T(state.T);
  annotation(Inline=true);
end thermalConductivity;
end LinearFLiBe_12Th_05U_pT;
