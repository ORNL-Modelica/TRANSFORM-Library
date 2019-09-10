within TRANSFORM.Units.Conversions.Functions.Pressure_Pa;
function from_MPa "Pressure: [MPa] -> [Pa]"
  extends BaseClasses.from;
algorithm
  y := u*1e6;
end from_MPa;
