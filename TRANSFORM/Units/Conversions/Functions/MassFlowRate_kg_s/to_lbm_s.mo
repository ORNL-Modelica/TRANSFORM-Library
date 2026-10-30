within TRANSFORM.Units.Conversions.Functions.MassFlowRate_kg_s;
function to_lbm_s "Mass Flow Rate: [kg/s] -> [lbm/s]"
  extends BaseClasses.to;
algorithm
  y :=Mass_kg.to_lbm(u)*1;
end to_lbm_s;
