within TRANSFORM.Units.Conversions.Functions.Power_W;
function from_btu_hr "Power: [btu(IT)/hr] -> [W]"
  extends BaseClasses.from;

algorithm
  y := u*1055.0558526/3600;
end from_btu_hr;
