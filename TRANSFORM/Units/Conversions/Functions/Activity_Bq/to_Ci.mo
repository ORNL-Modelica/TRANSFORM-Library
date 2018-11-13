within TRANSFORM.Units.Conversions.Functions.Activity_Bq;
function to_Ci "Activity: [Bq] -> [Ci]"
  extends BaseClasses.to;

algorithm
  y := u/(3.7e10);
end to_Ci;
