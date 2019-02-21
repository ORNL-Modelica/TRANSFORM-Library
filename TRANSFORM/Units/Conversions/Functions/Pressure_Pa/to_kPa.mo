within TRANSFORM.Units.Conversions.Functions.Pressure_Pa;
function to_kPa "Pressure: [Pa] -> [kPa]"
  extends BaseClasses.to;
algorithm
  y := u/1e3;
end to_kPa;
