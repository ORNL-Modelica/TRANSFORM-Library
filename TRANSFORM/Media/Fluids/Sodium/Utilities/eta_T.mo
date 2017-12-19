within TRANSFORM.Media.Fluids.Sodium.Utilities;
function eta_T
  input SI.Temperature T;
  output SI.DynamicViscosity eta;
algorithm
  eta:=7.9419e-5*exp(822.5/T);//-3.0655e-7*state.T+5.2303e-4
end eta_T;
