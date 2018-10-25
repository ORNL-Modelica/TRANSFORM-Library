within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_zepto "zepto: [1e-21] -> [1] | z -> -"
  extends BaseClasses.to;

algorithm
  y := u*1e-21;
end from_zepto;
