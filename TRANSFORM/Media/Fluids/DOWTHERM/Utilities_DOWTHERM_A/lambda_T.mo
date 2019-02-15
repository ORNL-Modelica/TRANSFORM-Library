within TRANSFORM.Media.Fluids.DOWTHERM.Utilities_DOWTHERM_A;
function lambda_T
  input SI.Temperature T;
  output SI.ThermalConductivity lambda;
algorithm
  lambda := 1.85606E-01 - 1.60002E-04*T;
end lambda_T;
