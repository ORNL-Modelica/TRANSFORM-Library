within TRANSFORM.Units.Conversions.Functions.Power_W;
function to_btu_hr "Power: [W] -> [btu(IT)/hr]"
  extends BaseClasses.to;

algorithm
  y := u/1055.0558526*3600;
end to_btu_hr;
