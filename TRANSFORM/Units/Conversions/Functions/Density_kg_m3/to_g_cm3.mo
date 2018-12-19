within TRANSFORM.Units.Conversions.Functions.Density_kg_m3;
function to_g_cm3 "Density: [kg/m^3] -> [g/cm^3]"
  extends BaseClasses.to;

algorithm
  y := u/1000;
end to_g_cm3;
