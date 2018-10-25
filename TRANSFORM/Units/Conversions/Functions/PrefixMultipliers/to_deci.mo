within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_deci "deci: [1] -> [1e-1] | - -> d"
  extends BaseClasses.to;

algorithm
  y := u/1e-1;
end to_deci;
