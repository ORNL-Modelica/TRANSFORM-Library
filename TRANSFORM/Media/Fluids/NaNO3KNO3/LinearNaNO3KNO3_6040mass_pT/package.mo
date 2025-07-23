within TRANSFORM.Media.Fluids.NaNO3KNO3;
package LinearNaNO3KNO3_6040mass_pT
  "NaNO3-KNO3 | 60%-40% by mass | Linear compressibility"
// https://www.osti.gov/servlets/purl/786629/ Section 1.6.3
// beta_const adjusted till density matched. kappa left alone
// references are based on 800K
// assumed specific enthalpy at 273.15 is zero
extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
  mediumName="Linear NaNO3-KNO3 60-40 mass",
  constantJacobian=false,
  reference_p=1e5,
  reference_T=450+273.15,
  reference_d=NaNO3KNO3.Utilities_NaNO3KNO3_6040mass.d_T(
                                  reference_T),
  reference_h=NaNO3KNO3.Utilities_NaNO3KNO3_6040mass.cp_T(
                                   reference_T)*(reference_T - 273.15),
  reference_s=0,
  beta_const=3.5258e-4,
  kappa_const=2.89e-10,
  cp_const=NaNO3KNO3.Utilities_NaNO3KNO3_6040mass.cp_T(
                                reference_T),
  MM_const=0.09143,
  T_default=450+273.15);

redeclare function extends dynamicViscosity "Dynamic viscosity"
algorithm
    eta := NaNO3KNO3.Utilities_NaNO3KNO3_6040mass.eta_T(state.T);
  annotation(Inline=true);
end dynamicViscosity;

redeclare function extends thermalConductivity
    "Thermal conductivity"
algorithm
    lambda := NaNO3KNO3.Utilities_NaNO3KNO3_6040mass.lambda_T(state.T);
  annotation(Inline=true);
end thermalConductivity;
end LinearNaNO3KNO3_6040mass_pT;
