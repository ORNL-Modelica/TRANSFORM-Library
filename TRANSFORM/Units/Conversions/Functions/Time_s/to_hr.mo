within TRANSFORM.Units.Conversions.Functions.Time_s;
function to_hr "Time: [s] -> [hr]"
  extends BaseClasses.to;
algorithm
  y := u/(60*60);
end to_hr;
