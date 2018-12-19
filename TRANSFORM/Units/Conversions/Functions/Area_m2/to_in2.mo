within TRANSFORM.Units.Conversions.Functions.Area_m2;
function to_in2 "Area: [m2] -> [in2]"
  extends BaseClasses.to;

algorithm
  y := u/(0.0254^2);
end to_in2;
