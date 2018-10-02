within TRANSFORM.Units.Conversions.Functions.TemperatureDifference_dK;
function to_degF_diff "Temperature Difference: [K] -> [degF/degR]"
  extends BaseClasses.to;

algorithm
  y := u*9/5;
end to_degF_diff;
