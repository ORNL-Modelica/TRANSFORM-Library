within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_mega "mega: [1e6] -> [1] | M -> -"
  extends BaseClasses.from;

algorithm
  y := u*1e6;
end from_mega;
