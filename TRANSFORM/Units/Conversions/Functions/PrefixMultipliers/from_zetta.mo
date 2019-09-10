within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_zetta "zetta: [1e21] -> [1] | Z -> -"
  extends BaseClasses.from;
algorithm
  y := u*1e21;
end from_zetta;
