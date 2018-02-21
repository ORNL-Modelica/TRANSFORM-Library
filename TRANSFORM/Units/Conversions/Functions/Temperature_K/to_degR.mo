within TRANSFORM.Units.Conversions.Functions.Temperature_K;
function to_degR "Temperature: [K] -> [degR]"
  extends BaseClasses.to;

algorithm
  y := u*9/5;
end to_degR;
