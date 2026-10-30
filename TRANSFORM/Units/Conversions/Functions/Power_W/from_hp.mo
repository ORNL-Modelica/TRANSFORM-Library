within TRANSFORM.Units.Conversions.Functions.Power_W;
function from_hp "Power: [hp] -> [W]"
  extends BaseClasses.from;
algorithm
  y := u*745.7;
end from_hp;
