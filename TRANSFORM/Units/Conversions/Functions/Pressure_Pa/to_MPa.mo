within TRANSFORM.Units.Conversions.Functions.Pressure_Pa;
function to_MPa "Pressure: [Pa] -> [MPa]"
  extends BaseClasses.to;

algorithm
  y := u/1e6;
end to_MPa;
