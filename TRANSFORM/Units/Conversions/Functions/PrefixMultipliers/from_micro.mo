within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_micro "micro: [1e-6] -> [1] | mu -> -"
  extends BaseClasses.from;
algorithm
  y := u*1e-6;
end from_micro;
