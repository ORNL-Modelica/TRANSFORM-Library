within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_femto "femto: [1] -> [1e-15] | - -> f"
  extends BaseClasses.to;
algorithm
  y := u/1e-15;
end to_femto;
