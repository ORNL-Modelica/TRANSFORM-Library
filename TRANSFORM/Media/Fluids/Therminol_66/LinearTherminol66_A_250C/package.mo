within TRANSFORM.Media.Fluids.Therminol_66;
package LinearTherminol66_A_250C "Therminol A | cp @ 250 C"
// beta_const adjusted till density matched. kappa left alone
// assumed specific enthalpy at 273.15 is zero
  extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
    mediumName="Linear Therminol 66",
    constantJacobian=false,
    reference_p=1e5,
    reference_T=250 + 273.15,
    reference_d=Utilities_Therminol_66.d_T(reference_T),
    reference_h=Utilities_Therminol_66.cp_T(reference_T)*(reference_T - 273.15),
    reference_s=0,
    beta_const=8.77e-4,
    kappa_const=2.89e-10,
    cp_const=Utilities_Therminol_66.cp_T(reference_T),
    MM_const=0.252,
    T_default=250 + 273.15);
    //Note: Kappa is useless
redeclare function extends dynamicViscosity "Dynamic viscosity"
algorithm
  eta :=Utilities_Therminol_66.eta_T(state.T);
  annotation(Inline=true);
end dynamicViscosity;

redeclare function extends thermalConductivity
    "Thermal conductivity"
algorithm
  lambda :=Utilities_Therminol_66.lambda_T(state.T);
  annotation(Inline=true);
end thermalConductivity;
end LinearTherminol66_A_250C;
