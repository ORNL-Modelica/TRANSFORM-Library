within TRANSFORM.Units.Conversions.Functions.Pressure_Pa;
function to_psi "Pressure: [Pa] -> [psi]"
  extends BaseClasses.to;

algorithm
  y := u/6894.75728;
end to_psi;
