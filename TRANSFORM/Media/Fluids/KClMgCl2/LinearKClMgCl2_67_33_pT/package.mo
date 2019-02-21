within TRANSFORM.Media.Fluids.KClMgCl2;
package LinearKClMgCl2_67_33_pT "KCl-MgCl2 | 67%-33% | Linear compressibility"
// beta_const adjusted till density matched. kappa left alone
// references are based on 1150K
// assumed specific enthalpy at 273.15 is zero
constant Real molFrac[2]={0.67,0.33} "Mole fraction of each species";
constant SI.MolarMass MM[2]={0.039098+0.03545,0.024305+2*0.03545} "Molar mass of each species";

  extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
    mediumName="Linear KCl-MgCl2",
    constantJacobian=false,
    reference_p=1e5,
    reference_T=1150,
    reference_d=Utilities_67_33.d_T(reference_T),
    reference_h=Utilities_67_33.cp_T(reference_T)*(reference_T - 273.15),
    reference_s=0,
    beta_const=3.09882e-4,
    kappa_const=2.89e-10,
    cp_const=Utilities_67_33.cp_T(reference_T),
    MM_const=sum(molFrac .* MM),
    T_default=1150);

redeclare function extends dynamicViscosity "Dynamic viscosity"
algorithm
  eta :=Utilities_67_33.eta_T(state.T);
  annotation(Inline=true);
end dynamicViscosity;

redeclare function extends thermalConductivity
    "Thermal conductivity"
algorithm
  lambda :=Utilities_67_33.lambda_T(state.T);
  annotation(Inline=true);
end thermalConductivity;
end LinearKClMgCl2_67_33_pT;
