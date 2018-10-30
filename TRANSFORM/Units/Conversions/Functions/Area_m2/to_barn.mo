within TRANSFORM.Units.Conversions.Functions.Area_m2;
function to_barn "Area: [m2] -> [b]"
  extends BaseClasses.to;

algorithm
  y := u/(1e-28);
end to_barn;
