within TRANSFORM.Units.Conversions.Functions.Distance_m;
function from_micron "Distance: [micron] -> [m]"
  extends BaseClasses.from;
algorithm
  y := u*1e-6;
end from_micron;
