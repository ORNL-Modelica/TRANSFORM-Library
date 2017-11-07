within TRANSFORM.Units.Conversions.Functions.Energy_J;
function from_btu "Energy: [btu] -> [J]"
  extends BaseClasses.from;

algorithm
  y := u*1055.0558526;
end from_btu;
