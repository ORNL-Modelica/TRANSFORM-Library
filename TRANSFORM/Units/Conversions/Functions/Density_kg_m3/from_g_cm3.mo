within TRANSFORM.Units.Conversions.Functions.Density_kg_m3;
function from_g_cm3 "Density: [g/cm^3] -> [kg/m^3]"
  extends BaseClasses.from;
algorithm
  y := u*1000;
end from_g_cm3;
