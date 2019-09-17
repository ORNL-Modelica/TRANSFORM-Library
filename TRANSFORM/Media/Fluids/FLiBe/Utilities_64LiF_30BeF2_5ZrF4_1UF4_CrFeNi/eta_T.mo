within TRANSFORM.Media.Fluids.FLiBe.Utilities_64LiF_30BeF2_5ZrF4_1UF4_CrFeNi;
function eta_T
  input SI.Temperature T;
  output SI.DynamicViscosity eta;
algorithm
  eta:=0.116e-3*exp(3755/T);
end eta_T;
