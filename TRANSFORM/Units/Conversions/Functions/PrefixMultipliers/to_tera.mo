within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_tera "tera: [1] -> [1e12] | - -> T"
extends BaseClasses.to;
algorithm
y := u/1e12;
end to_tera;
