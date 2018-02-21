within TRANSFORM.Media.Fluids.FLiBe.Utilities_12Th_05U;
function eta_T

  import TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degR;
  import TRANSFORM.Units.Conversions.Functions.DynamicViscosity_kg_ms.from_lb_hrfeet;

  input SI.Temperature T;
  output SI.DynamicViscosity eta;
algorithm
  eta:=from_lb_hrfeet(0.2637*exp(7362/to_degR(T)));
end eta_T;
