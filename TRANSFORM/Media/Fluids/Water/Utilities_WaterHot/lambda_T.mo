within TRANSFORM.Media.Fluids.Water.Utilities_WaterHot;
function lambda_T
  input SI.Temperature T;
  output SI.ThermalConductivity lambda;
protected
  Real c[:] = {-5.07469277e-06,4.20288013e-03,-1.78694789e-01};
  Integer nC = size(c,1);
algorithm
    lambda :=sum({c[i]*T^(nC - i) for i in 1:nC});
end lambda_T;
