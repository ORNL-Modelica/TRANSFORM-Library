within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_yotta "yotta: [1e24] -> [1] | Y -> -"
  extends BaseClasses.from;
algorithm
  y := u*1e24;
end from_yotta;
