within TRANSFORM.Units.Conversions.Functions.Time_s;
function from_yr "Time: [year] -> [s]"
  extends BaseClasses.from;

algorithm
  y := u*60*60*24*365;
end from_yr;
