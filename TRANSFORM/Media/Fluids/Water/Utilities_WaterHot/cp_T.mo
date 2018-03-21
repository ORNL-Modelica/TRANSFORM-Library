within TRANSFORM.Media.Fluids.Water.Utilities_WaterHot;
function cp_T
  input SI.Temperature T;
  output SI.SpecificHeatCapacity cp;
protected
  Real c[:] = {4.1075749617613013, -5650.8665560981999, 8.7313628135952666, 4.1931010264902353};
  Integer nC = size(c,1);

algorithm
    cp :=(c[1]*exp(c[2]/T+c[3]) + c[4])*1e3;

end cp_T;
