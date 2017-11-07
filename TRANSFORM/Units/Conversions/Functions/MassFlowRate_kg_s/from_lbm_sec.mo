within TRANSFORM.Units.Conversions.Functions.MassFlowRate_kg_s;
function from_lbm_sec "Mass Flow Rate: [lbm/s] -> [kg/s]"
  extends BaseClasses.from;

algorithm
  y :=Mass_kg.from_lbm(u)*1;
end from_lbm_sec;
