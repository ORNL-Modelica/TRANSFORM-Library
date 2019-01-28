within TRANSFORM.Units.Conversions.Functions.SpecificHeatAndEntropy_J_kgK;
function from_cal_gK
  "Specific Heat Capacity: [cal/(g*K)] -> [J/(kg*K)]"
  extends BaseClasses.to;

algorithm
  y := u*4186.798188;
end from_cal_gK;
