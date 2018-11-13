within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_giga "giga: [1] -> [1e9] | - -> G"
extends BaseClasses.to;

algorithm
y := u/1e9;
end to_giga;
