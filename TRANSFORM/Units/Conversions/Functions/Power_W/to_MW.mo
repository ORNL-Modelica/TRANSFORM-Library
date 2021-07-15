within TRANSFORM.Units.Conversions.Functions.Power_W;
function to_MW "Power: [W] -> [MW]"
  extends BaseClasses.to;
algorithm
  y := u/1e6;
end to_MW;
