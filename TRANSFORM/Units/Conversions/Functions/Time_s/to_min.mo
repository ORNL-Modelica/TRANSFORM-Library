within TRANSFORM.Units.Conversions.Functions.Time_s;
function to_min "Time: [s] -> [min]"
  extends BaseClasses.to;

algorithm
  y := u/60;
end to_min;
