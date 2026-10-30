within TRANSFORM.Units.Conversions.Functions.MassFlowRate_kg_s;
function from_lbm_hr "Mass Flow Rate: [lbm/hr] -> [kg/s]"
  extends BaseClasses.from;
algorithm
  y :=Mass_kg.from_lbm(u)/3600;
end from_lbm_hr;
