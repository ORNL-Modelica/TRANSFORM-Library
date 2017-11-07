within TRANSFORM.Units.Conversions.Functions.Distance_m;
function to_feet "Distance: [m] -> [ft]"
  extends BaseClasses.to;

algorithm
  y := u/(12*0.0254);
end to_feet;
