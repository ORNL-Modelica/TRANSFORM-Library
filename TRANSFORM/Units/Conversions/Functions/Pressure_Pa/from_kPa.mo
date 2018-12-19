within TRANSFORM.Units.Conversions.Functions.Pressure_Pa;
function from_kPa "Pressure: [kPa] -> [Pa]"
  extends BaseClasses.from;

algorithm
  y := u*1e3;
end from_kPa;
