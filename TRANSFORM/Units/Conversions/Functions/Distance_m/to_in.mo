within TRANSFORM.Units.Conversions.Functions.Distance_m;
function to_in "Distance: [m] -> [in]"
  extends BaseClasses.to;

algorithm
  y := u/0.0254;
end to_in;
