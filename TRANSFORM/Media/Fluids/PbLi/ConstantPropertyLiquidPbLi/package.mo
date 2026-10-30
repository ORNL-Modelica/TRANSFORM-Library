within TRANSFORM.Media.Fluids.PbLi;
package ConstantPropertyLiquidPbLi "PbLi: Simple liquid lead-lithium medium (incompressible, constant data)"
  /*
Properties have been calculated at 470C (743K)
*/
  constant Modelica.Media.Interfaces.Types.Basic.FluidConstants[1]
    simplePbLiConstants(
    each chemicalFormula="PbLi",
    each structureFormula="PbLi",
    each casRegistryNumber="9999-99-9",
    each iupacName="pbli",
    each molarMass=0.17576);

  extends Modelica.Media.Interfaces.PartialSimpleMedium(
    mediumName="SimpleLiquidPbLi",
    cp_const=188,
    cv_const=141,
    d_const=9637,
    eta_const=0.001231,
    lambda_const=0.165,
    a_const=1785,
    T_min=508,
    T_max=1000,
    T0=298.15,
    MM_const=0.17576,
    fluidConstants=simplePbLiConstants);

  annotation (Documentation(info="<html>

</html>"));
end ConstantPropertyLiquidPbLi;
