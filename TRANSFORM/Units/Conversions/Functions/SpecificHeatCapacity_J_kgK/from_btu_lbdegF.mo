within TRANSFORM.Units.Conversions.Functions.SpecificHeatCapacity_J_kgK;
function from_btu_lbdegF
  "Specific Heat Capacity: [Btu/(lb*degF)] -> [J/(kg*K)]"
  extends BaseClasses.from;

algorithm
  y := u*4186.798188;
end from_btu_lbdegF;
