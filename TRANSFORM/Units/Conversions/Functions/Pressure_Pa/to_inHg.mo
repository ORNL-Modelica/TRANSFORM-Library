within TRANSFORM.Units.Conversions.Functions.Pressure_Pa;
function to_inHg "Pressure: [Pa] -> [inHg]"
  extends BaseClasses.to;
algorithm
  y := u/3386.389;
end to_inHg;
