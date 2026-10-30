within TRANSFORM.Units.Conversions.Functions.PrefixMultipliers;
function from_yocto "yocto: [1e-24] -> [1] | y -> -"
  extends BaseClasses.from;
algorithm
  y := u*1e-24;
end from_yocto;
