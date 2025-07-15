within TRANSFORM.Units.Conversions.Functions.Pressure_Pa;
function from_Torr "Pressure: [Torr] -> [Pa]"
  extends BaseClasses.from;
algorithm
  y := u * 133.322368;
end from_Torr;
