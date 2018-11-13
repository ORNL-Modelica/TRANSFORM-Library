within TRANSFORM.Units.Conversions.Functions.Time_s;
function to_yr "Time: [s] -> [year]"
  extends BaseClasses.to;

algorithm
  y := u/(60*60*24*365);
end to_yr;
