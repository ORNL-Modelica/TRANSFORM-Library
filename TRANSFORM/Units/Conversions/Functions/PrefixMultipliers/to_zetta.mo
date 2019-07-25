within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_zetta "zetta: [1] -> [1e21] | - -> Z"
extends BaseClasses.to;
algorithm
y := u/1e21;
end to_zetta;
