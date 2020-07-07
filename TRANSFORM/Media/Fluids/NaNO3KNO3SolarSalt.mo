within TRANSFORM.Media.Fluids;
package NaNO3KNO3SolarSalt "NaNO3-KNO3-package"
extends Modelica.Icons.VariantsPackage;
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

  package Utilities_50_50_SolarSalt
    "It is assumed that there is an equal molar ratio."
  import TRANSFORM;

  extends TRANSFORM.Icons.UtilitiesPackage;

    function d_T
      input SI.Temperature T;
      output SI.Density d;
    algorithm
      d:= 2263.628 - 0.636*(T);
    end d_T;

    function eta_T
      input SI.Temperature T;
      output SI.DynamicViscosity eta;
    algorithm
      eta:=0.075439-2.77e-4*(T-273)+3.49e-7*(T-273)^2-1.474e-10*(T-273)^3;
    end eta_T;

    function lambda_T
      input SI.Temperature T;
      output SI.ThermalConductivity lambda;
    algorithm
      lambda:=0.45;
    end lambda_T;

    function cp_T
      input SI.Temperature T;
      output SI.SpecificHeatCapacity cp;
    algorithm
      cp:=1396.044+0.172*T;
    end cp_T;
  annotation (Documentation(info="<html>
<p>Source:</p>
<p>All properties except thermal conductivity and heat capacity:</p>
<p>Raseman CJ, Susskind H, Farber G, McNulty WE, Salzano FJ (1960) Engineering Experience At Brookhaven National Laboratory In Handling Fused Chloride Salts. Brookhaven National Lab., Upton, N.Y. </p>
<p><br>Thermal conductivity and heat capacity:</p>
<p>Petroski R, Hejzlar P, Todreas NE (2009) Thermal hydraulic design of a liquid salt-cooled flexible conversion ratio fast reactor. Nuclear Engineering and Design 239:2612&ndash;2625 . doi: 10.1016/j.nucengdes.2009.07.012 </p>
</html>"));
  end Utilities_50_50_SolarSalt;
end NaNO3KNO3SolarSalt;
