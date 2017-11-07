within TRANSFORM.Units.Conversions.Functions.Distance_m;
function to_cm "Distance: [m] -> [cm]"
  extends BaseClasses.to;

algorithm
  y := u*100;
end to_cm;
