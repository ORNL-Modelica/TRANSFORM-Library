within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_kilo "kilo: [1e3] -> [1] | k -> -"
  extends BaseClasses.from;

algorithm
  y := u*1e3;
end from_kilo;
