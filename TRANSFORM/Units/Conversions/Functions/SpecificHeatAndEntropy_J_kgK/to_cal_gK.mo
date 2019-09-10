within TRANSFORM.Units.Conversions.Functions.SpecificHeatAndEntropy_J_kgK;
function to_cal_gK
  "Specific Heat Capacity: [J/(kg*K)] -> [cal/(g*K)]"
  extends BaseClasses.to;
algorithm
  y := u/4186.798188;
end to_cal_gK;
