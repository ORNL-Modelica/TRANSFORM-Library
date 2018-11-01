within TRANSFORM.Units.Conversions.Functions.Area_m2;
function to_inch2 "Area: [m2] -> [inch2]"
  extends BaseClasses.to;

algorithm
  y := u/(0.0254^2);
end to_inch2;
