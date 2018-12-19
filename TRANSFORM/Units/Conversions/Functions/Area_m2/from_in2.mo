within TRANSFORM.Units.Conversions.Functions.Area_m2;
function from_in2 "Area: [in2] -> [m2]"
  extends BaseClasses.from;

algorithm
  y := u*0.0254^2;
end from_in2;
