within TRANSFORM.Units.Conversions.Functions.SpecificActivity_Bq;
function to_Ci "Activity: [Bq/kg] -> [Ci/kg]"
  extends BaseClasses.to;

algorithm
  y := u/(3.7e10);
end to_Ci;
