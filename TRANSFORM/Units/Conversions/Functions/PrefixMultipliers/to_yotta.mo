within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_yotta "yotta: [1] -> [1e24] | - -> Y"
extends BaseClasses.to;

algorithm
y := u/1e24;
end to_yotta;
