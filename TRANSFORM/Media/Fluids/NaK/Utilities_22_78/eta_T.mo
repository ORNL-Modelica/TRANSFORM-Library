within TRANSFORM.Media.Fluids.NaK.Utilities_22_78;
function eta_T

  import TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degR;
  import
    TRANSFORM.Units.Conversions.Functions.DynamicViscosity_kg_ms.from_lb_hrfeet;

  input SI.Temperature T;
  output SI.DynamicViscosity eta;
algorithm
  eta:=9.3083e-5*exp(556/T);
end eta_T;
