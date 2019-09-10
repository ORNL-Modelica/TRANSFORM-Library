within TRANSFORM.Units.Conversions.Functions.Mass_kg;
function to_lbm "Mass: [kg] -> [lbm]"
  extends BaseClasses.to;
algorithm
  y := u*1/0.453592;
end to_lbm;
