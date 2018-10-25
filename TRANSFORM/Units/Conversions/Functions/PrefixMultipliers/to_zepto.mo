within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_zepto "zepto: [1] -> [1e-21] | - -> z"
  extends BaseClasses.to;

algorithm
  y := u/1e-21;
end to_zepto;
