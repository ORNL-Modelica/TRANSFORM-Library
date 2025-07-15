within TRANSFORM.Units.Conversions.Functions.Pressure_Pa;
function to_Torr "Pressure: [Pa] -> [torr]"
  extends BaseClasses.to;
algorithm
  y := u / 133.322368;
end to_Torr;
