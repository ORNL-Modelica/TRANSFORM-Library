within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_hecto "hecto: [1e2] -> [1] | h -> -"
  extends BaseClasses.from;

algorithm
  y := u*1e2;
end from_hecto;
