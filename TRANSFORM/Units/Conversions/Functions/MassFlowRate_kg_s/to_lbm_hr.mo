within TRANSFORM.Units.Conversions.Functions.MassFlowRate_kg_s;
function to_lbm_hr "Mass Flow Rate: [kg/s] -> [lbm/hr]"
  extends BaseClasses.to;
algorithm
  y :=Mass_kg.to_lbm(u)*3600;
end to_lbm_hr;
