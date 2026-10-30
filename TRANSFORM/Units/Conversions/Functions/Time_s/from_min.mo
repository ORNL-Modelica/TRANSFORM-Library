within TRANSFORM.Units.Conversions.Functions.Time_s;
function from_min "Time: [min] -> [s]"
  extends BaseClasses.from;
algorithm
  y := u*60;
end from_min;
