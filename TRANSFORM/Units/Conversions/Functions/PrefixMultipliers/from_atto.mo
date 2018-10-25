within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_atto "atto: [1e-18] -> [1] | a -> -"
  extends BaseClasses.to;

algorithm
  y := u*1e-18;
end from_atto;
