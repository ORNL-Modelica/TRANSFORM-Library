within TRANSFORM.Media.Fluids.NaK;
package LinearNaK_22_78_pT "NaK | NaK 22%-78% | Linear compressibility"
  // THERMOPHYSICAL PROPERTIES OF MATERIALS FOR NUCLEAR ENGINEERING
  // beta_const adjusted till density matched. kappa left alone
  // assumed specific enthalpy at 273.15 is zero
  extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
    mediumName="Linear NaK",
    constantJacobian=false,
    reference_p=1e5,
    reference_T=550,
    reference_d=TRANSFORM.Media.Fluids.NaK.Utilities_22_78.d_T(reference_T),
    reference_h=TRANSFORM.Media.Fluids.NaK.Utilities_22_78.cp_T(reference_T)*(
        reference_T - 273.15),
    reference_s=0,
    beta_const=3.0286e-4,
    kappa_const=2.89e-10,
    cp_const=TRANSFORM.Media.Fluids.NaK.Utilities_22_78.cp_T(reference_T),
    MM_const=0.033,
    T_default=800);

  redeclare function extends dynamicViscosity "Dynamic viscosity"
  algorithm
    eta := TRANSFORM.Media.Fluids.NaK.Utilities_22_78.eta_T(state.T);
    annotation (Inline=true);
  end dynamicViscosity;

  redeclare function extends thermalConductivity
    "Thermal conductivity"
  algorithm
    lambda := TRANSFORM.Media.Fluids.NaK.Utilities_22_78.lambda_T(state.T);
    annotation (Inline=true);
  end thermalConductivity;
end LinearNaK_22_78_pT;
