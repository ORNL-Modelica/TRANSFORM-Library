within TRANSFORM.Units.Conversions.Functions.Distance_m;
function to_mm "Distance: [m] -> [mm]"
  extends BaseClasses.to;

algorithm
  y := u*1000;
end to_mm;
