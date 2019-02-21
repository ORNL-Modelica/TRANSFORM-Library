within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_exa "exa: [1] -> [1e18] | - -> E"
extends BaseClasses.to;
algorithm
y := u/1e18;
end to_exa;
