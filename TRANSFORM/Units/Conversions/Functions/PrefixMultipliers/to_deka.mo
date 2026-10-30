within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_deka "value: [1] -> [1e1] | - -> da"
  extends BaseClasses.to;
algorithm
  y := u/1e1;
end to_deka;
