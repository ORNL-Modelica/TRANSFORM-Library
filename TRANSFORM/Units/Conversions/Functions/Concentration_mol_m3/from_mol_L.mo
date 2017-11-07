within TRANSFORM.Units.Conversions.Functions.Concentration_mol_m3;
function from_mol_L "Concentration: [mol/L] -> [mol/m3]"
  extends BaseClasses.from;

algorithm
  y := u*1000;
end from_mol_L;
