within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function to_yocto "yocto: [1] -> [1e-24] | - -> y"
  extends BaseClasses.to;
algorithm
  y := u/1e-24;
end to_yocto;
