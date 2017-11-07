within TRANSFORM.Units.Conversions.Functions.Distance_m;
function from_feet "Distance: [ft] -> [m]"
  extends BaseClasses.from;

algorithm
  y := u*12*0.0254;
end from_feet;
