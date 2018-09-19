within TRANSFORM.Media.Fluids.DOWTHERM.Utilities_DOWTHERM_A;
function eta_T

  input SI.Temperature T;
  output SI.DynamicViscosity eta;

algorithm
  eta := 4.31224E-06*exp(2021.208061/T);
end eta_T;
