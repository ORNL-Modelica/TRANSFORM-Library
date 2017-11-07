within TRANSFORM.Units.Conversions.Functions.Distance_m;
function to_micron "Distance: [m] -> [micron]"
  extends BaseClasses.to;

algorithm
  y := u*1e6;
end to_micron;
