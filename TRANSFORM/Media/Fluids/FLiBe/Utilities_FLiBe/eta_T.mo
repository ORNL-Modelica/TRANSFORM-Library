within TRANSFORM.Media.Fluids.FLiBe.Utilities_FLiBe;
function eta_T
  input SI.Temperature T;
  output SI.DynamicViscosity eta;
algorithm
  // ORNL/TM-2006/12 Fig. 10
  eta:=1.16e-4*exp(3755/T);
end eta_T;
