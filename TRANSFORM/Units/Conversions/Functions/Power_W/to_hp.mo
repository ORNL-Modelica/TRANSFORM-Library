within TRANSFORM.Units.Conversions.Functions.Power_W;
function to_hp "Power: [W] -> [hp]"
  extends BaseClasses.to;

algorithm
  y := u/745.7;
end to_hp;
