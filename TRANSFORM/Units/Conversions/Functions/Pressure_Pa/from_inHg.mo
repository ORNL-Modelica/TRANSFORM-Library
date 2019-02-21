within TRANSFORM.Units.Conversions.Functions.Pressure_Pa;
function from_inHg "Pressure: [inHg] -> [Pa]"
  extends BaseClasses.from;
algorithm
  y := u*3386.389;
end from_inHg;
