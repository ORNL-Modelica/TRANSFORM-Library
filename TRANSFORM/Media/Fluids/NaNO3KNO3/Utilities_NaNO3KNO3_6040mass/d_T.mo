within TRANSFORM.Media.Fluids.NaNO3KNO3.Utilities_NaNO3KNO3_6040mass;
function d_T
  input SI.Temperature T;
  output SI.Density d;
algorithm
  // https://www.osti.gov/servlets/purl/786629/ Section 1.6.3
  d:=-0.636*(T-273.15)+2090;
end d_T;
