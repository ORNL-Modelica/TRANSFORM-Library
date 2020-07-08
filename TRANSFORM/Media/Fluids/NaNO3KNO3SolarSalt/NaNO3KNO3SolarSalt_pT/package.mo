within TRANSFORM.Media.Fluids.NaNO3KNO3SolarSalt;
package NaNO3KNO3SolarSalt_pT "NaNo3-KNO3 Solar Salt from Reference 
    (Molten salts database for energy applications)
    R. Serrano-Lópeza, J. Fraderaa, S. Cuesta-Lópeza"
  import elem = TRANSFORM.PeriodicTable.Elements;
// beta_const adjusted till density matched. kappa left alone
// references are based on temperatures between 573 and 873 K
// assumed specific enthalpy at 273.15 is zero
  extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
    mediumName="NaNo3-KNO3-SolarSalt",
    constantJacobian=false,
    reference_p=1e5,
    reference_T=800,
    reference_d=Utilities_50_50_SolarSalt.d_T(reference_T),
    reference_h=Utilities_50_50_SolarSalt.cp_T(reference_T)*(reference_T - 273.15),
    reference_s=0,
    beta_const=4.20515e-4,
    kappa_const=2.89e-10,
    cp_const=Utilities_50_50_SolarSalt.cp_T(reference_T),
    MM_const=0.5*(elem.Na.MM + elem.N.MM + 3*elem.O.MM) +
             0.5*(elem.K.MM + elem.N.MM + 3*elem.O.MM),  T_default=800);

redeclare function extends dynamicViscosity "Dynamic viscosity"
algorithm
  eta :=Utilities_50_50_SolarSalt.eta_T(state.T);
  annotation(Inline=true);
end dynamicViscosity;

redeclare function extends thermalConductivity
    "Thermal conductivity"
algorithm
  lambda :=Utilities_50_50_SolarSalt.lambda_T(state.T);
  annotation(Inline=true);
end thermalConductivity;

annotation (Documentation(info="<html>
</html>"));
end NaNO3KNO3SolarSalt_pT;
