within TRANSFORM.Media.Fluids;
package Lithium "Fluid properties for lithium"
  extends Modelica.Icons.VariantsPackage;
  package ConstantPropertyLiquidLithium
    "Lithium: Simple liquid lithium medium (incompressible, constant data)"
    /*
Properties have been calculated based on a weighted average basis between T_min and T_max
*/
    constant Modelica.Media.Interfaces.Types.Basic.FluidConstants[1]
      simpleLithiumConstants(
      each chemicalFormula="Li",
      each structureFormula="Li",
      each casRegistryNumber="7439-93-2",
      each iupacName="lithium",
      each molarMass=0.0694);

    extends Modelica.Media.Interfaces.PartialSimpleMedium(
      mediumName="SimpleLiquidLithium",
      cp_const=4207,
      cv_const=4207,
      d_const=467.356,
      eta_const=3.879e-4,
      lambda_const=55.885,
      a_const=1,
      T_min=455,
      T_max=1500,
      T0=298.15,
      MM_const=0.0694,
      T_default = 800,
      fluidConstants=simpleLithiumConstants);

    annotation (Documentation(info="<html>

</html>"));
  end ConstantPropertyLiquidLithium;
constant Modelica.Media.Interfaces.Types.TwoPhase.FluidConstants[1]
  lithiumConstants(
  each chemicalFormula="Li",
  each structureFormula="Li",
  each casRegistryNumber="7439-93-2",
  each iupacName="lithium",
  each molarMass=0.0694,
  each criticalTemperature=3220,
  each criticalPressure=67e6,
  each criticalMolarVolume=Modelica.Constants.R*lithiumConstants.criticalTemperature/lithiumConstants.criticalPressure,
  each normalBoilingPoint=1615,
  each meltingPoint=454,
  each triplePointTemperature=454,
  each triplePointPressure=1e5,
  each acentricFactor=1,
  each dipoleMoment=1,
  each hasCriticalData=true);
  package Lithium_Incompressible "Lithium | Incompressible"
    //Based on summary by S. Zinkle "Summary of Physical Properties for Lithium, Pb-17Li, and (LiF)n•BeF2 Coolants"
    //http://www.fusion.ucla.edu/APEX/meeting4/1zinkle0798.pdf
    extends Modelica.Media.Incompressible.TableBased(
    T_default=673.15,
    npol=1,
      mediumName="Lithium: Incompressible",
      T_min=455,
      T_max=1600,
      TinK=true,
      T0=455,
      tableDensity= [ 455,514.62;
                      500,510.742;
                      600,502.071;
                      700,493.326;
                      800,484.502;
                      900,475.595;
                     1000,466.601;
                     1100,457.512;
                     1200,448.324;
                     1300,439.030;
                     1400,429.622;
                     1500,420.092],
      tableHeatCapacity=[ 455,4393.37;
                          500,4364.25;
                          600,4303.76;
                          700,4249.09;
                          800,4200.24;
                          900,4157.21;
                         1000,4120.00;
                         1100,4088.61;
                         1200,4063.04;
                         1300,4043.29;
                         1400,4029.36;
                         1500,4021.25],
      tableConductivity=[ 455,42.457;
                          500,44.173;
                          600,47.805;
                          700,51.189;
                          800,54.325;
                          900,57.212;
                         1000,59.850;
                         1100,62.240;
                         1200,64.381;
                         1300,66.273;
                         1400,67.917;
                         1500,69.313],
      tableViscosity=[ 455,0.0005973;
                       500,0.0005309;
                       600,0.0004288;
                       700,0.0003625;
                       800,0.0003160;
                       900,0.0002815;
                      1000,0.0002548;
                      1100,0.0002335;
                      1200,0.0002161;
                      1300,0.0002015;
                      1400,0.0001892;
                      1500,0.0001785],
      tableVaporPressure=[ 455,2.20676E-08;
                           500,8.81836E-07;
                           600,0.000435930;
                           700,0.036189999;
                           800,0.986556072;
                           900,12.81323640;
                          1000,99.10573804;
                          1100,526.0775770;
                          1200,2106.431778;
                          1300,6791.655454;
                          1400,18475.27214;
                          1500,43876.74877]);

      annotation (Documentation(info="<html>
<p>Table units:</p>
<p>Temperature: K</p>
<p>Density: kg/m^2</p>
<p>Constant Pressure Specific Heat Capacity: J/(kg-K)</p>
<p>Dynamic Viscosity: N-s/m^2</p>
<p>Thermal Conductivity: W/(m-K)</p>
<p><br><br>Source:</p>
<p>Thermal-Fluids Central: Engine Oil, Unused</p>
<p>URL:https://www.thermalfluidscentral.org/encyclopedia/index.php/Thermophysical_Properties:_Engine_Oil,_Unused</p>
<p>Data references:</p>
<ol>
<li><span style=\"font-family: sans-serif; background-color: #ffffff;\">Bejan, A., 2004, Convection Heat Transfer, 3rd ed., John Wiley &AMP; Sons, New York, NY.</span></li>
<li><span style=\"font-family: sans-serif; background-color: #ffffff;\">Faghri Amir , Zhang Yuwen , Howell John, 2010, Advanced Heat and Mass Transfer, Global Digital Press, Columbia, MO</span></li>
</ol>
</html>"));
  end Lithium_Incompressible;

  package Utilities
  import TRANSFORM;

  extends TRANSFORM.Icons.UtilitiesPackage;
    function d_T
      input SI.Temperature T;
      output SI.Density d;
    algorithm
      d:=-0.24093*T+1.0196e3;
    end d_T;

    function eta_T
      input SI.Temperature T;
      output SI.DynamicViscosity eta;
    algorithm
      eta:=7.9419e-5*exp(822.5/T);//-3.0655e-7*state.T+5.2303e-4
    end eta_T;

    function lambda_T
      input SI.Temperature T;
      output SI.ThermalConductivity lambda;
    algorithm
      lambda:=-0.043096*T + 99.3504;
    end lambda_T;

    function cp_T
      input SI.Temperature T;
      output SI.SpecificHeatCapacity cp;
    algorithm
      cp:=7.4338e-3*T+1.287e3;
    end cp_T;
  end Utilities;
end Lithium;
