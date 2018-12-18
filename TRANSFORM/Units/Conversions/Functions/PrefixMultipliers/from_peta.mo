within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_peta "peta: [1e15] -> [1] | P -> -"
  extends BaseClasses.from;

algorithm
  y := u*1e15;
end from_peta;
