within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_deka "deka: [1e1] -> [1] | da -> -"
  extends BaseClasses.to;

algorithm
  y := u*1e1;
end from_deka;
