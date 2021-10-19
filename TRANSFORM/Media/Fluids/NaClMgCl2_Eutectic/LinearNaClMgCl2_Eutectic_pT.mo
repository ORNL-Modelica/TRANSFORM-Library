within TRANSFORM.Media.Fluids.NaClMgCl2_Eutectic;
package LinearNaClMgCl2_Eutectic_pT
  import elem = TRANSFORM.PeriodicTable.Elements;
  extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
  mediumName="Linear NaClMgCl2_Eutectic",
  constantJacobian=false,
  reference_p=1e5,
  reference_T=973,
  reference_d=Utilities.d_T(reference_T),
  reference_h=Utilities.cp_T(reference_T)*(reference_T-273.15),
  reference_s=0,
  beta_const=4.20515e-4,
  kappa_const=2.89e-10,
  cp_const=Utilities.cp_T(reference_T),
  MM_const=0.58*(elem.Na.MM + elem.Cl.MM) + 0.42*(elem.Mg.MM + 2*elem.Mg.MM),
  T_default=973);

redeclare function extends dynamicViscosity "Dynamic viscosity"
algorithm
  eta :=Utilities.eta_T(state.T);
  annotation(Inline=true);
end dynamicViscosity;

redeclare function extends thermalConductivity
    "Thermal conductivity"
algorithm
  lambda :=Utilities.lambda_T(state.T);
  annotation(Inline=true);
end thermalConductivity;
end LinearNaClMgCl2_Eutectic_pT;
