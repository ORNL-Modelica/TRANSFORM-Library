within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_mega "mega: [1] -> [1e6] | - -> M"
extends BaseClasses.to;

algorithm
y := u/1e6;
end to_mega;
