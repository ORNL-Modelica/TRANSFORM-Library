within TRANSFORM.Units.Conversions.Functions.Concentration_mol_m3;
function to_mol_L "Concentration: [mol/m3] -> [mol/L]"
  extends BaseClasses.to;

algorithm
  y := u/1000;
end to_mol_L;
