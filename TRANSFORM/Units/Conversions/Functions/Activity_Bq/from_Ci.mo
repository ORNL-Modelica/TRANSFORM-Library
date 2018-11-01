within TRANSFORM.Units.Conversions.Functions.Activity_Bq;
function from_Ci "Activity: [Ci] -> [Bq]"
  extends BaseClasses.from;

algorithm
  y := u*3.7e10;
end from_Ci;
