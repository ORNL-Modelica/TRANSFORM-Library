within TRANSFORM.Media.Fluids.KFZrF4.Utilities;
function eta_T
  input SI.Temperature T;
  output SI.DynamicViscosity eta;
algorithm
  eta:=1.59e-4*exp(3179/T);
end eta_T;
