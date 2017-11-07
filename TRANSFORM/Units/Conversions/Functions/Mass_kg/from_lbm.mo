within TRANSFORM.Units.Conversions.Functions.Mass_kg;
function from_lbm "Mass: [lbm] -> [kg]"
  extends BaseClasses.from;

algorithm
  y := u*0.453592;
end from_lbm;
