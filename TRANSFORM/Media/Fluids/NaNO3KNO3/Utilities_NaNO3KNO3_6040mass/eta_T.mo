within TRANSFORM.Media.Fluids.NaNO3KNO3.Utilities_NaNO3KNO3_6040mass;
function eta_T
  input SI.Temperature T;
  output SI.DynamicViscosity eta;
algorithm
  // https://www.osti.gov/servlets/purl/786629/ Section 1.6.3
  //eta:=1e-3*(22.714-0.120*(T-273.15)+2.281e-4*(T-273.15)^2-1.474e-7*(T-273.15)^3);
  eta:=1.21e-4*exp(1841/T); // Derived from fitting polynomial equation. Has 4% average error over range 300-600°C as compared to polynomial form.

end eta_T;
