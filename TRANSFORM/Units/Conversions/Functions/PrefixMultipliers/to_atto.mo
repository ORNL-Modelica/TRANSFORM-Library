within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_atto "atto: [1] -> [1e-18] | - -> a"
  extends BaseClasses.to;
algorithm
  y := u/1e-18;
end to_atto;
