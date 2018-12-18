within TRANSFORM.Units.Conversions.Functions.SpecificHeatCapacity_J_kgK;
function to_btu_lbdegF
  "Specific Heat Capacity: [J/(kg*K)] -> [btu(IT)/(lb*degF)]"
  extends BaseClasses.to;

algorithm
  y := u/4186.798188;
end to_btu_lbdegF;
