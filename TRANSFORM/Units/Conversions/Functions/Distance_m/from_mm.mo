within TRANSFORM.Units.Conversions.Functions.Distance_m;
function from_mm "Distance: [mm] -> [m]"
  extends BaseClasses.from;

algorithm
  y := u/1000;
end from_mm;
