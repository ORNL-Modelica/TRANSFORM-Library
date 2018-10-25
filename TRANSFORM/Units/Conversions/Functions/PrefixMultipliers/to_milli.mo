within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_milli "milli: [1] -> [1e-3] | - -> m"
  extends BaseClasses.to;

algorithm
  y := u/1e-3;
end to_milli;
