within TRANSFORM.Units.Conversions.Functions.TemperatureDifference_dK;
function to_degForR_diff "Temperature Difference: [K] -> [degF or degR]"
  extends BaseClasses.to;
algorithm
  y := u*9/5;
end to_degForR_diff;
