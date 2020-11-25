within TRANSFORM.Media.Fluids;
package NaClUCl3 "NaCl-UCl3 (67-33) Molten Salt"
extends Modelica.Icons.VariantsPackage;
  package LinearNaClUCl3_67_33_pT
    "NaCl-UCl3 | 67%-33% | Linear compressibility"
  // beta_const adjusted till density matched. kappa left alone
  // references are based on 1150K
  // assumed specific enthalpy at 273.15 is zero
  constant Real molFrac[2]={0.67,0.33} "Mole fraction of each species";
  constant SI.MolarMass MM[2]={0.02299+0.03545,0.23803+3*0.03545} "Molar mass of each species";

    extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
      mediumName="Linear NaCl-UCl3",
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
  end LinearNaClUCl3_67_33_pT;

  package Utilities_67_33
  import TRANSFORM;

  //1.MANOHAR S. SOHAL et al., “Engineering Database of Liquid Salt Thermophysical and Thermochemical Properties,” INL/EXT-10-18297, 980801 (2010); https://doi.org/10.2172/980801.

  extends TRANSFORM.Icons.UtilitiesPackage;

    function d_T
      input SI.Temperature T;
      output SI.Density d;
    algorithm
     // d:=2000.7-0.45709*T;
      d:=4960-2.009*T;
    end d_T;

    function eta_T
      import TRANSFORM.Math.spliceTanh;
      input SI.Temperature T;
      output SI.DynamicViscosity eta;
    algorithm
      eta:=1.86e-5*exp(9308/(1.987*T));
      //  eta:=1.408e-4*exp(2262.979/T);
    end eta_T;

    function lambda_T
      input SI.Temperature T;
      output SI.ThermalConductivity lambda;
    algorithm
      lambda:=0.75;
    end lambda_T;

    function cp_T
      input SI.Temperature T;
      output SI.SpecificHeatCapacity cp;
    algorithm
      cp:=600;
    end cp_T;
  annotation (Documentation(info="<html>
<p>Source:</p>
<p>1. MANOHAR S. SOHAL et al., &ldquo;Engineering Database of Liquid Salt Thermophysical and Thermochemical Properties,&rdquo; INL/EXT-10-18297, 980801 (2010); https://doi.org/<a href=\"https://doi.org/10.2172/980801\">10.2172/980801</a>. </p>
</html>"));
  end Utilities_67_33;
end NaClUCl3;
