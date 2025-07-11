within TRANSFORM.Media.Fluids.NaNO3KNO3.Utilities_NaNO3KNO3_6040mass;
function cp_T
  input SI.Temperature T;
  output SI.SpecificHeatCapacity cp;
algorithm
  // https://www.osti.gov/servlets/purl/786629/ Section 1.6.3
  cp:=1443+0.172*(T-273.15);
end cp_T;
