within TRANSFORM.Media.Fluids;
package Therminol_66 "Therminol66"

extends Modelica.Icons.VariantsPackage;
  package Utilities_Therminol_66
    import TRANSFORM;
   // “DOWTHERM A Heat Transfer Fluid Product Technical Data.” 1997. Dow Chemical Company. http://msdssearch.dow.com/PublishedLiteratureDOWCOM/dh_0030/0901b803800303cd.pdf.
    extends TRANSFORM.Icons.UtilitiesPackage;
    function d_T
      // Note: linear fit from 15 - 300 C, not over full range of source data
      input SI.Temperature T;
      output SI.Density d;
    algorithm
      d :=-0.614254*(T-273.15) - 0.000321*(T-273.15)^2.0 + 1020.62;
    end d_T;

    function eta_T
      input SI.Temperature T;
      output SI.DynamicViscosity eta;
    algorithm
      eta :=d_T(T-273.15)*exp((586.375/((T-273.15) + 62.5)) - 2.2809);
    end eta_T;

    function lambda_T
      input SI.Temperature T;
      output SI.ThermalConductivity lambda;
    algorithm
      lambda :=-0.000033*(T-273.15) - 0.00000015*((T-273.15)^2) + 0.118294;
    end lambda_T;

    function cp_T
      // Note: linear fit from 15 - 300 C, not over full range of source data
      input SI.Temperature T;
      output SI.SpecificHeatCapacity cp;
    algorithm
      cp :=0.003313*(T-273.15) + 0.0000008970785*(T-273.15)^2 + 1.496005;
    end cp_T;
  end Utilities_Therminol_66;

  package LinearTherminol66_A_250C "Therminol A | cp @ 250 C"
  // beta_const adjusted till density matched. kappa left alone
  // assumed specific enthalpy at 273.15 is zero
    extends TRANSFORM.Media.Interfaces.Fluids.PartialLinearFluid(
      mediumName="Linear Therminol 66",
      constantJacobian=false,
      reference_p=1e5,
      reference_T=250 + 273.15,
      reference_d=Utilities_Therminol_66.d_T(reference_T),
      reference_h=Utilities_Therminol_66.cp_T(reference_T)*(reference_T - 273.15),
      reference_s=0,
      beta_const=8.77e-4,
      kappa_const=2.89e-10,
      cp_const=Utilities_Therminol_66.cp_T(reference_T),
      MM_const=0.252,
      T_default=250 + 273.15);
      //Note: Kappa is useless
  redeclare function extends dynamicViscosity "Dynamic viscosity"
  algorithm
    eta :=Utilities_Therminol_66.eta_T(state.T);
    annotation(Inline=true);
  end dynamicViscosity;

  redeclare function extends thermalConductivity
      "Thermal conductivity"
  algorithm
    lambda :=Utilities_Therminol_66.lambda_T(state.T);
    annotation(Inline=true);
  end thermalConductivity;
  end LinearTherminol66_A_250C;
end Therminol_66;
