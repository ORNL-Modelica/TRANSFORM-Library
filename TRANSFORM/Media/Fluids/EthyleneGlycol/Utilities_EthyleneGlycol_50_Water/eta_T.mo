within TRANSFORM.Media.Fluids.EthyleneGlycol.Utilities_EthyleneGlycol_50_Water;
function eta_T
  input SI.Temperature T;
  output SI.DynamicViscosity eta;
algorithm
  eta :=(-0.00001474*(T-273.15)^3.0 + 0.00474114*(T-273.15)^2.0 - 0.50420746*(T-273.15) + 20.08866)*1e-3;
end eta_T;
