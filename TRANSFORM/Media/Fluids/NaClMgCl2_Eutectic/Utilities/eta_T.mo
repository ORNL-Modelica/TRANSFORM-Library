within TRANSFORM.Media.Fluids.NaClMgCl2_Eutectic.Utilities;
function eta_T
  input SI.Temperature T;
  output SI.DynamicViscosity eta;
algorithm
  eta:=1.36e-4;
end eta_T;
