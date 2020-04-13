within TRANSFORM.Media.Fluids.Therminol_66.Utilities_Therminol_66;
function lambda_T
  input SI.Temperature T;
  output SI.ThermalConductivity lambda;
algorithm
  lambda :=-0.000033*(T-273.15) - 0.00000015*((T-273.15)^2) + 0.118294;
end lambda_T;
