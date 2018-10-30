within TRANSFORM.Units.Conversions.Functions.SpecificActivity_Bq;
function from_Ci "Activity: [Ci/kg] -> [Bq/kg]"
  extends BaseClasses.from;

algorithm
  y := u*3.7e10;
end from_Ci;
