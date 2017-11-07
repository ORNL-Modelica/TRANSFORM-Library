within TRANSFORM.Units.Conversions.Functions.Distance_m;
function from_m "Distance: [m] -> [m]"
  extends BaseClasses.from;

algorithm
  y := u*100;
end from_m;
