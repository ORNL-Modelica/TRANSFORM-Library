within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_nano "nano: [1e-9] -> [1] | n -> -"
  extends BaseClasses.from;
algorithm
  y := u*1e-9;
end from_nano;
