within TRANSFORM.Media.Fluids.NaNO3KNO3.Utilities_NaNO3KNO3_6040mass;
function lambda_T
  input SI.Temperature T;
  output SI.ThermalConductivity lambda;
algorithm
  // https://www.osti.gov/servlets/purl/786629/ Section 1.6.3
  lambda:=1.9e-4*(T-273.15) + 0.443;
end lambda_T;
