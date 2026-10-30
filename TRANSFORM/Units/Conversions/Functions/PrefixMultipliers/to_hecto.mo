within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_hecto "hecto: [1] -> [1e2] | - -> h"
  extends BaseClasses.to;
algorithm
  y := u/1e2;
end to_hecto;
