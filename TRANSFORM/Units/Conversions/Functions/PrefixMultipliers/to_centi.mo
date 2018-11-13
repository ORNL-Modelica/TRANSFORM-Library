within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_centi "centi: [1] -> [1e-2] | - -> c"
  extends BaseClasses.to;

algorithm
  y := u/1e-2;
end to_centi;
