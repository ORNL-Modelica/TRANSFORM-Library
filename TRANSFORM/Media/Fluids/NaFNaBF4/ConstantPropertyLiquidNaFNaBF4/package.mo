within TRANSFORM.Media.Fluids.NaFNaBF4;
package ConstantPropertyLiquidNaFNaBF4 "NaFNaBF4i: Molten fluoroborate salt (incompressible, constant data)"

  /*
  Properties have been calculated at 540C (813K)
*/

  constant Modelica.Media.Interfaces.Types.Basic.FluidConstants[1]
    simpleNaFNaBF4Constants(
    each chemicalFormula="NaFNaBF4",
    each structureFormula="NaFNaBF4",
    each casRegistryNumber="9999-99-9",
    each iupacName="nafnabf4",
    each molarMass=0.104363);

  extends Modelica.Media.Interfaces.PartialSimpleMedium(
    mediumName="SimpleLiquidNaFNaBF4",
    cp_const=1507,
    cv_const=1130,
    d_const=1871,
    eta_const=0.001602,
    lambda_const=0.5,
    a_const=1372,
    T_min=658,
    T_max=1600,
    T0=298.15,
    MM_const=0.104363,
    fluidConstants=simpleNaFNaBF4Constants);

  annotation (Documentation(info="<html>

</html>"));
end ConstantPropertyLiquidNaFNaBF4;
