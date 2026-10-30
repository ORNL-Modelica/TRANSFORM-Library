within TRANSFORM.Media.Fluids.FLiNaK.Utilities;
function eta_T
  input SI.Temperature T;
  output SI.DynamicViscosity eta;
algorithm
  eta:=4e-5*exp(4170/T);
end eta_T;
