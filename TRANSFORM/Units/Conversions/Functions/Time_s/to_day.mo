within TRANSFORM.Units.Conversions.Functions.Time_s;
function to_day "Time: [s] -> [day]"
  extends BaseClasses.to;
algorithm
  y := u/(60*60*24);
end to_day;
