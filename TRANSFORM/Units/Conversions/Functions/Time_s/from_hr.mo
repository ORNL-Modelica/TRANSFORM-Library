within TRANSFORM.Units.Conversions.Functions.Time_s;
function from_hr "Time: [hr] -> [s]"
  extends BaseClasses.from;
algorithm
  y := u*60*60;
end from_hr;
