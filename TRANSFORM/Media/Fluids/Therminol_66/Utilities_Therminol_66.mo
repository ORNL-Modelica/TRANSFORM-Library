within TRANSFORM.Media.Fluids.Therminol_66;
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
