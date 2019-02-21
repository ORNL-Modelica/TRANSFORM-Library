within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_tera "tera: [1e12] -> [1] | T -> -"
  extends BaseClasses.from;
algorithm
  y := u*1e12;
end from_tera;
