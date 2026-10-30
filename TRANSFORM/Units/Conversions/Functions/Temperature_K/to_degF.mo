within TRANSFORM.Units.Conversions.Functions.Temperature_K;
function to_degF "Temperature: [K] -> [degF]"
  extends BaseClasses.to;
algorithm
  y := u*9/5 - 459.67;
end to_degF;
