within TRANSFORM.Media.Fluids.FLiBe;
package ConstantPropertyLiquidFLiBe "FLiBe: Simple LiF-BeF2 medium (incompressible, constant data)"

  /*
Properties have been calculated based on a weighted average basis between T_min and T_max
*/

  constant Modelica.Media.Interfaces.Types.Basic.FluidConstants[1]
    simpleFLiBeConstants(
    each chemicalFormula="LiFBeF2",
    each structureFormula="LiFBeF2",
    each casRegistryNumber="9999-99-9",
    each iupacName="flibe",
    each molarMass=0.072948);

  extends Modelica.Media.Interfaces.PartialSimpleMedium(
    mediumName="SimpleLiquidFLiBe",
    cp_const=2380,
    cv_const=1785,
    d_const=1948,
    eta_const=0.006,
    lambda_const=1.1059,
    a_const=2441,
    T_min=850,
    T_max=1050,
    T0=298.15,
    MM_const=0.072948,
    fluidConstants=simpleFLiBeConstants);

  annotation (Documentation(info="<html>

</html>"));
end ConstantPropertyLiquidFLiBe;
