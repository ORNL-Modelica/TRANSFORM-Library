within TRANSFORM.Units.Conversions.Functions.Distance_m;
function to_ft "Distance: [m] -> [ft]"
  extends BaseClasses.to;
algorithm
  y := u/(12*0.0254);
end to_ft;
