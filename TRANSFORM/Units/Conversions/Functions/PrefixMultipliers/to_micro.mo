within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_micro "micro: [1] -> [1e-6] | - -> mu"
  extends BaseClasses.to;

algorithm
  y := u/1e-6;
end to_micro;
