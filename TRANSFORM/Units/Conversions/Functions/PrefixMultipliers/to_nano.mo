within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_nano "nano: [1] -> [1e-9] | - -> n"
  extends BaseClasses.to;

algorithm
  y := u/1e-9;
end to_nano;
