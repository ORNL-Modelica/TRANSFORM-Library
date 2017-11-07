within TRANSFORM.Units.Conversions.Functions.Pressure_Pa;
function from_psi "Pressure: [psi] -> [Pa]"
  extends BaseClasses.from;

algorithm
  y := u*6894.75728;
end from_psi;
