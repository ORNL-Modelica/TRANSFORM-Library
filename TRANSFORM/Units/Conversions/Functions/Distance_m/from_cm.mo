within TRANSFORM.Units.Conversions.Functions.Distance_m;
function from_cm "Distance: [cm] -> [m]"
  extends BaseClasses.from;
algorithm
  y := u/100;
end from_cm;
