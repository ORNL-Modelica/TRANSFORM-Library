within TRANSFORM.Units.Conversions.Functions.Time_s;
function from_day "Time: [day] -> [s]"
  extends BaseClasses.from;
algorithm
  y := u*60*60*24;
end from_day;
