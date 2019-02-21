within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_kilo "kilo: [1] -> [1e3] | - -> k"
extends BaseClasses.to;
algorithm
y := u/1e3;
end to_kilo;
