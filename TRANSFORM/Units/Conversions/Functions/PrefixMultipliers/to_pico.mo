within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_pico "pico: [1] -> [1e-12] | - -> p"
  extends BaseClasses.to;

algorithm
  y := u/1e-12;
end to_pico;
