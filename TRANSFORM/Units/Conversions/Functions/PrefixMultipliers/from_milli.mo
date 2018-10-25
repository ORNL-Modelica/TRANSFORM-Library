within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_milli "milli: [1e-3] -> [1] | m -> -"
  extends BaseClasses.to;

algorithm
  y := u*1e-3;
end from_milli;
