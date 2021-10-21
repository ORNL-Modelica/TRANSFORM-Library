within TRANSFORM.Media.Fluids.NaClKClMgCl2;
package LinearNaClKClMgCl2_30_20_50_pT_option2 "NaClKClMgCl2 | NaCl-KCl-MgCl2 30%-20%-50% | Linear compressibility"
  import elem = TRANSFORM.PeriodicTable.Elements;
// beta_const adjusted till density matched. kappa left alone
// references are based on 800K
// assumed specific enthalpy at 273.15 is zero
extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
  mediumName="Linear NaClKClMgCl2",
  constantJacobian=false,
  reference_p=1e5,
  reference_T=800,
  reference_d=Utilities_30_20_50.d_T(reference_T,option=2),
  reference_h=Utilities_30_20_50.cp_T(reference_T,option=2)*(reference_T - 273.15),
  reference_s=0,
  beta_const=3.531775e-4,
  kappa_const=2.89e-10,
  cp_const=Utilities_30_20_50.cp_T(reference_T,option=2),
  MM_const=0.3*(elem.Na.MM + elem.Cl.MM) + 0.2*(elem.K.MM + elem.Cl.MM) + 0.5*(
      elem.Mg.MM + 2*elem.Cl.MM),
  T_default=800);

redeclare function extends dynamicViscosity "Dynamic viscosity"
algorithm
  eta :=Utilities_30_20_50.eta_T(state.T,option=2);
  annotation(Inline=true);
end dynamicViscosity;

redeclare function extends thermalConductivity
    "Thermal conductivity"
algorithm
  lambda :=Utilities_30_20_50.lambda_T(state.T,option=2);
  annotation(Inline=true);
end thermalConductivity;

annotation (Documentation(info="<html>
</html>"));
end LinearNaClKClMgCl2_30_20_50_pT_option2;
