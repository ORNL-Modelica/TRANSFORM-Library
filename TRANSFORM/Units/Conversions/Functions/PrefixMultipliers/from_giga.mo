within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_giga "giga: [1e9] -> [1] | G -> -"
  extends BaseClasses.from;

algorithm
  y := u*1e9;
end from_giga;
