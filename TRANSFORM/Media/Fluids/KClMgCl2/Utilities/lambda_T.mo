within TRANSFORM.Media.Fluids.KClMgCl2.Utilities;
function lambda_T
  input SI.Temperature T;
  output SI.ThermalConductivity lambda;
algorithm
  lambda:=0.2469 + 5.025e-4*T;
end lambda_T;
