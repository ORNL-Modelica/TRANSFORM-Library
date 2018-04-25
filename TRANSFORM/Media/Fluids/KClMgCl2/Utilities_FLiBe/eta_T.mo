within TRANSFORM.Media.Fluids.KClMgCl2.Utilities_FLiBe;
function eta_T
  input SI.Temperature T;
  output SI.DynamicViscosity eta;
algorithm
  eta:=1.16e-4*exp(3755/T);
end eta_T;
