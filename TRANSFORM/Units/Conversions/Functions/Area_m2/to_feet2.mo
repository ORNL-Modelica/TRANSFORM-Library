within TRANSFORM.Units.Conversions.Functions.Area_m2;
function to_feet2 "Area: [m2] -> [feet2]"
  extends BaseClasses.to;

algorithm
  y := u/(0.0254^2*12^2);
end to_feet2;
