within TRANSFORM.Media.Fluids.NaClKClMgCl2.Utilities_30_20_50;
function eta_T
  input SI.Temperature T;
  output SI.DynamicViscosity eta;
algorithm
  eta:=1e-3*exp(3040/T-2.96);
end eta_T;
