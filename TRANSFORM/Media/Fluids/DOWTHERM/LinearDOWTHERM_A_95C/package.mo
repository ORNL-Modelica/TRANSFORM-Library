within TRANSFORM.Media.Fluids.DOWTHERM;
package LinearDOWTHERM_A_95C "DOWTHERM A | cp @ 95 C"
// beta_const adjusted till density matched. kappa left alone
// assumed specific enthalpy at 273.15 is zero
  extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
    mediumName="Linear DOWTHERM A",
    constantJacobian=false,
    reference_p=1e5,
    reference_T=95+273.15,
    reference_d=Utilities_DOWTHERM_A.d_T(reference_T),
    reference_h=Utilities_DOWTHERM_A.cp_T(reference_T)*(reference_T - 273.15),
    reference_s=0,
    beta_const=8.94016e-4,
    kappa_const=2.89e-10,
    cp_const=Utilities_DOWTHERM_A.cp_T(reference_T),
    MM_const=0.166,
    T_default=95+273.15);

redeclare function extends dynamicViscosity "Dynamic viscosity"
algorithm
  eta :=Utilities_DOWTHERM_A.eta_T(state.T);
  annotation(Inline=true);
end dynamicViscosity;

redeclare function extends thermalConductivity
    "Thermal conductivity"
algorithm
  lambda :=Utilities_DOWTHERM_A.lambda_T(state.T);
  annotation(Inline=true);
end thermalConductivity;
end LinearDOWTHERM_A_95C;
