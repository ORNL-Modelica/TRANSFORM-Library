within TRANSFORM.Units.Conversions.Functions.Distance_m;
function to_inch "Distance: [m] -> [in]"
  extends BaseClasses.to;

algorithm
  y := u/0.0254;
end to_inch;
