within TRANSFORM.Media.Fluids.Water;
package LinearWaterHot_pT "Water | Ref. p=15.5 MPa, T=550 K | Linear compressibility"

// beta_const adjusted till density matched. kappa left alone
// assumed specific enthalpy at 273.15 is zero
  extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
    mediumName="Linear FLiBe",
    constantJacobian=false,
    reference_p=15.5e6,
    reference_T=550,
    reference_d=Utilities_WaterHot.d_T(reference_T),
    reference_h=Utilities_WaterHot.cp_T(reference_T)*(reference_T - 273.15),
    reference_s=0,
    beta_const=1.393044e-3,
    kappa_const=5.0433e-9,
    cp_const=Utilities_WaterHot.cp_T(reference_T),
    MM_const=0.01802,
    T_default=550);

redeclare function extends dynamicViscosity "Dynamic viscosity"

algorithm
  eta :=Utilities_WaterHot.eta_T(state.T);
  annotation(Inline=true);
end dynamicViscosity;

redeclare function extends thermalConductivity
    "Thermal conductivity"
algorithm
  lambda :=Utilities_WaterHot.lambda_T(state.T);
  annotation(Inline=true);
end thermalConductivity;
end LinearWaterHot_pT;
