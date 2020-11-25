within TRANSFORM.Media.Fluids.EthyleneGlycol.Utilities_EthyleneGlycol_50_Water;
function lambda_T
  input SI.Temperature T;
  output SI.ThermalConductivity lambda;
algorithm
  lambda :=(8.9758*(1e-5)*(T-273.15) - 1.3975*(1e-6)*((T-273.15)^2) + 0.23951)*1.7295772056;
end lambda_T;
