within TRANSFORM.Units.Conversions.Functions.Area_m2;
function from_barn "Area: [b] -> [m2]"
  extends BaseClasses.from;
algorithm
  y := u*1e-28;
end from_barn;
