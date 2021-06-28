within TRANSFORM.Units.Conversions.Functions.SpecificEnergy_J_kg;
function from_kJ_kg "Specific Energy: [kJ/kg] -> [J/kg]"
  extends BaseClasses.from;
algorithm
  y := u*1000;
end from_kJ_kg;
