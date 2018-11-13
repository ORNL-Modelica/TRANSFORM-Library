within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_femto "femto: [1e-15] -> [1] | f -> -"
  extends BaseClasses.to;

algorithm
  y := u*1e-15;
end from_femto;
