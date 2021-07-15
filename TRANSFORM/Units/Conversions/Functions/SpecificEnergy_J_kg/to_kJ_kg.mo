within TRANSFORM.Units.Conversions.Functions.SpecificEnergy_J_kg;
function to_kJ_kg "Specific Energy: [J/kg] -> [kJ/kg]"
  extends BaseClasses.to;
algorithm
  y := u/1000;
end to_kJ_kg;
