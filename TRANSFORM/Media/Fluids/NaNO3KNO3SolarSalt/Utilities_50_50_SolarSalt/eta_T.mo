within TRANSFORM.Media.Fluids.NaNO3KNO3SolarSalt.Utilities_50_50_SolarSalt;
function eta_T
  input SI.Temperature T;
  output SI.DynamicViscosity eta;
algorithm
  eta:=0.075439-2.77e-4*(T-273)+3.49e-7*(T-273)^2-1.474e-10*(T-273)^3;
end eta_T;
