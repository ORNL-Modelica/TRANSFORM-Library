within TRANSFORM.Units.Conversions.Functions.Temperature_K;
function from_degR "Temperature: [degR] -> [K]"
  extends BaseClasses.from;

algorithm
  y := u*5/9;
end from_degR;
