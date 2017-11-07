within TRANSFORM.Units.Conversions.Functions.Distance_m;
function to_m "Distance: [m] -> [m]"
  extends BaseClasses.to;

algorithm
  y := u*100;
end to_m;
