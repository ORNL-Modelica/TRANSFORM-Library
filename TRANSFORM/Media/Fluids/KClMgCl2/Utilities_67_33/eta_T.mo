within TRANSFORM.Media.Fluids.KClMgCl2.Utilities_67_33;
function eta_T
  import TRANSFORM.Math.spliceTanh;
  input SI.Temperature T;
  output SI.DynamicViscosity eta;
algorithm
  eta:=1.408e-4*exp(2262.979/T);
end eta_T;
