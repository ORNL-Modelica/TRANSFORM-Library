within TRANSFORM.Units.Conversions.Functions.MassFlowRate_kg_s;
function from_lbm_min "Mass Flow Rate: [lbm/min] -> [kg/s]"
  extends BaseClasses.from;

algorithm
  y :=Mass_kg.from_lbm(u)/60;
end from_lbm_min;
