within TRANSFORM.Media.Fluids;
package KClMgCl2New "KCl-MgCl2-New (68-32 mole fraction %)"

extends Modelica.Icons.VariantsPackage;

  package LinearKClMgCl2New_pT "KClMgCl2New | Linear compressibility"

    import elem = TRANSFORM.PeriodicTable.Elements;

  // beta_const adjusted till density matched. kappa left alone
  // references are based on 800K
  // assumed specific enthalpy at 273.15 is zero

  extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
    mediumName="Linear KClMgCl2New",
    constantJacobian=false,
    reference_p=1e5,
    reference_T=800,
    reference_d=Utilities.d_T(reference_T),
    reference_h=Utilities.cp_T(reference_T)*(reference_T - 273.15),
    reference_s=0,
    beta_const=4.20515e-4,
    kappa_const=2.89e-10,
    cp_const=Utilities.cp_T(reference_T),
    MM_const=0.68*(elem.K.MM + elem.Cl.MM) + 0.32*(elem.Mg.MM + 2*elem.Cl.MM),
    T_default=800);

  redeclare function extends dynamicViscosity "Dynamic viscosity"

  algorithm
      eta := Utilities.eta_T(state.T);
    annotation(Inline=true);
  end dynamicViscosity;

  redeclare function extends thermalConductivity
      "Thermal conductivity"
  algorithm
      lambda := Utilities.lambda_T(state.T);
    annotation(Inline=true);
  end thermalConductivity;

  annotation (Documentation(info="<html>
</html>"));
  end LinearKClMgCl2New_pT;

  package Utilities
  import TRANSFORM;

  extends TRANSFORM.Icons.UtilitiesPackage;

    function d_T
      input SI.Temperature T;
      output SI.Density d;
    algorithm
      d:=1903.0-0.552*(T-273);
    end d_T;

    function eta_T
      input SI.Temperature T;
      output SI.DynamicViscosity eta;
    algorithm
      eta:=(14.965-0.0291*(T-273)+(0.00001784)*(T-273)*(T-273))*0.001;
    end eta_T;

    function lambda_T
      input SI.Temperature T;
      output SI.ThermalConductivity lambda;
    algorithm
      lambda:=0.5047-0.0001*(T-273);
    end lambda_T;

    function cp_T
      input SI.Temperature T;
      output SI.SpecificHeatCapacity cp;
    algorithm
      cp:=1000.0;
    end cp_T;
  annotation (Documentation(info="<html>
<p>Source:</p>
<p>All properties except thermal conductivity and heat capacity:</p>
<p>Raseman CJ, Susskind H, Farber G, McNulty WE, Salzano FJ (1960) Engineering Experience At Brookhaven National Laboratory In Handling Fused Chloride Salts. Brookhaven National Lab., Upton, N.Y. </p>
<p><br>Thermal conductivity and heat capacity:</p>
<p>Petroski R, Hejzlar P, Todreas NE (2009) Thermal hydraulic design of a liquid salt-cooled flexible conversion ratio fast reactor. Nuclear Engineering and Design 239:2612&ndash;2625 . doi: 10.1016/j.nucengdes.2009.07.012 </p>
</html>"));
  end Utilities;
end KClMgCl2New;
