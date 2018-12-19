within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_centi "centi: [1e-2] -> [1] | c -> -"
  extends BaseClasses.from;

algorithm
  y := u*1e-2;
end from_centi;
