within TRANSFORM.Media.Fluids.Sodium;
package Sodium_simpleLinear "Sodium: Simple, linear properties"
  /*
Properties have been calculated based on a weighted average basis between T_min and T_max
*/
  constant Modelica.Media.Interfaces.Types.Basic.FluidConstants[1]
    simpleSodiumConstants(
    each chemicalFormula="Na",
    each structureFormula="Na",
    each casRegistryNumber="7440-23-5",
    each iupacName="sodium",
    each molarMass=0.02298976928);

  extends TRANSFORM.Media.Interfaces.Fluids.PartialSimpleMedium_other(
    mediumName="SimpleLiquidSodium",
    cp_T_coef={7.4338e-3,1.287e3},
    d_T_coef={-0.24093,1.0196e3},
    eta_T_coef={-3.0655e-7,5.2303e-4},
    lambda_T_coef={-0.043096,99.3504},
    a_T_coef={-0.54835,2.7331e3},
    cp_const=1251,
    cv_const=1076,
    d_const=863,
    eta_const=2.9957e-4,
    lambda_const=71.016,
    a_const=2377,
    T_min=273.15,
    T_max=1400,
    T0=298.15,
    MM_const=0.02298976928,
    T_default = 800,
    fluidConstants=simpleSodiumConstants);

  annotation (Documentation(info="<html>

</html>"));
end Sodium_simpleLinear;
