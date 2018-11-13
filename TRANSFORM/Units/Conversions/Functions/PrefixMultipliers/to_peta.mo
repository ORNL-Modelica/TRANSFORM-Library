within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_peta "peta: [1] -> [1e15] | - -> P"
extends BaseClasses.to;

algorithm
y := u/1e15;
end to_peta;
