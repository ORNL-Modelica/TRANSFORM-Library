within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_deci "deci: [1e-1] -> [1] | d -> -"
  extends BaseClasses.from;
algorithm
  y := u*1e-1;
end from_deci;
