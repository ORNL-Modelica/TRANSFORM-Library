within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_exa "exa: [1e18] -> [1] | E -> -"
  extends BaseClasses.from;
algorithm
  y := u*1e18;
end from_exa;
