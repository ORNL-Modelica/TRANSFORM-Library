within TRANSFORM.Units.Conversions.Functions.Pressure_Pa;
function to_atm "Pressure: [Pa] -> [atm]"
  extends BaseClasses.to;

algorithm
  y := u/101325;
end to_atm;
