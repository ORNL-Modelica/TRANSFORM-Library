within TRANSFORM.Units.Conversions.Functions.MassFlowRate_kg_s;
function to_lbm_min "Mass Flow Rate: [kg/s] -> [lbm/min]"
  extends BaseClasses.to;

algorithm
  y :=Mass_kg.to_lbm(u)*60;
end to_lbm_min;
