within TRANSFORM.Media.Fluids.FLiBe;
package LinearFLiBe_64LiF_30BeF2_5ZrF4_1UF4_CrFeNi "FLiBe (MSRE fuel salt) | LiF-BeF2-ZrF4-UF4-Cr-Fe-Ni, 64.1/64.5-30.0/30.4-5.0/4.9-0.809/0.137% 64/80-130/157-67/46 ppm | Linear compressibility"
  // ORNL-TM-4865 Table 2.1 and 2.2
// beta_const adjusted till density matched. kappa left alone
// references are based on 800K
// assumed specific enthalpy at 273.15 is zero
extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
  mediumName="Linear FLiBe",
  constantJacobian=false,
  reference_p=1e5,
  reference_T=800,
  reference_d=Utilities_64LiF_30BeF2_5ZrF4_1UF4_CrFeNi.d_T(reference_T),
  reference_h=Utilities_64LiF_30BeF2_5ZrF4_1UF4_CrFeNi.cp_T(reference_T)*(reference_T - 273.15),
  reference_s=0,
  beta_const=2.22586e-4,
  kappa_const=5.5072154e-11,
  cp_const=Utilities_64LiF_30BeF2_5ZrF4_1UF4_CrFeNi.cp_T(reference_T),
  MM_const=0.033,
  T_default=800);

redeclare function extends dynamicViscosity "Dynamic viscosity"
algorithm
  eta :=Utilities_64LiF_30BeF2_5ZrF4_1UF4_CrFeNi.eta_T(state.T);
  annotation(Inline=true);
end dynamicViscosity;

redeclare function extends thermalConductivity
    "Thermal conductivity"
algorithm
  lambda :=Utilities_64LiF_30BeF2_5ZrF4_1UF4_CrFeNi.lambda_T(state.T);
  annotation(Inline=true);
end thermalConductivity;
end LinearFLiBe_64LiF_30BeF2_5ZrF4_1UF4_CrFeNi;
