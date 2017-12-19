within TRANSFORM.Media.Fluids.NaFZrF4.Utilities;
function eta_T
  input SI.Temperature T;
  output SI.DynamicViscosity eta;
algorithm
  eta:=7.67e-5*exp(3977/T);
end eta_T;
