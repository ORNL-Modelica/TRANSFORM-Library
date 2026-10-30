within TRANSFORM.Media.Fluids.Water.Utilities_WaterHot;
function eta_T
  input SI.Temperature T;
  output SI.DynamicViscosity eta;
protected
  Real c[:] = {5.5808071028313786e-06, 1489.2184879839522};
  Integer nC = size(c,1);
algorithm
    eta :=c[1]*exp(c[2]/T);
end eta_T;
