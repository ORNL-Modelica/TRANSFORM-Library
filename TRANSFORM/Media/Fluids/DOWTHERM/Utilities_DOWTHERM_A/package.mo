within TRANSFORM.Media.Fluids.DOWTHERM;
package Utilities_DOWTHERM_A
  import TRANSFORM;

 // “DOWTHERM A Heat Transfer Fluid Product Technical Data.” 1997. Dow Chemical Company. http://msdssearch.dow.com/PublishedLiteratureDOWCOM/dh_0030/0901b803800303cd.pdf.


  extends TRANSFORM.Icons.UtilitiesPackage;

  function d_T

    // Note: linear fit from 15 - 300 C, not over full range of source data
    input SI.Temperature T;
    output SI.Density d;

  algorithm
    d := -8.91977e-1*T + 1.32610e03;
  end d_T;

  function eta_T

    input SI.Temperature T;
    output SI.DynamicViscosity eta;

  algorithm
    eta := 4.31224E-06*exp(2021.208061/T);
  end eta_T;

  function lambda_T

    input SI.Temperature T;
    output SI.ThermalConductivity lambda;

  algorithm
    lambda := 1.85606E-01 - 1.60002E-04*T;
  end lambda_T;

  function cp_T

    // Note: linear fit from 15 - 300 C, not over full range of source data
    input SI.Temperature T;
    output SI.SpecificHeatCapacity cp;

  algorithm
    cp := 2.79813*T + 7.54676e2;

  end cp_T;
end Utilities_DOWTHERM_A;
