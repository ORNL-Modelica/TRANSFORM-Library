within TRANSFORM.Units.Conversions.Functions.Energy_J;
function to_btu "Energy: [J] -> [btu]"
  extends BaseClasses.to;
algorithm
  y := u*1/1055.0558526;
end to_btu;
