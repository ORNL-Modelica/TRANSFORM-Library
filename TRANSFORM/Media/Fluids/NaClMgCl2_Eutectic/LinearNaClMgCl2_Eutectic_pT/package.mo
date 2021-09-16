within TRANSFORM.Media.Fluids.LinearNaClMgCl2_Eutectic_pt;
package LinearNaClMgCl2_Eutectic_pt "NaCl-MgCl2 Eutectic Salt Linear Compressibility"
  import elem = TRANSFORM.PeriodicTable.Elements;
// beta_const adjusted till density matched. kappa left alone
// references are based on 973K
// assumed specific enthalpy at 273.15 is zero
extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
  mediumName="Linear NaCl-MgCl2 Eutectic Salt",
  constantJacobian=false,
  reference_p=1e5,
  reference_T=973,
  reference_d=Utilities.d_T(reference_T),
  reference_h=Utilities.cp_T(reference_T)*(reference_T - 273.15),
  reference_s=0,
  beta_const=4.20515e-4,
  kappa_const=2.89e-10,
  cp_const=Utilities.cp_T(reference_T),
  MM_const=(elem.Na.MM + elem.Cl.MM) + (elem.Mg.MM + 2*elem.Cl.MM),
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

annotation (Documentation(info="<html>
</html>"));
end LinearNaClMgCl2_Eutectic_pt;
