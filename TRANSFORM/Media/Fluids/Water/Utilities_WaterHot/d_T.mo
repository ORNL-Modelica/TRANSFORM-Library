within TRANSFORM.Media.Fluids.Water.Utilities_WaterHot;
function d_T
  input SI.Temperature T;
  output SI.Density d;
protected
  Real c[:] = {-1.07607146e+00,1.36429971e+03};
  Integer nC = size(c,1);

algorithm
    d :=sum({c[i]*T^(nC - i) for i in 1:nC});

end d_T;
