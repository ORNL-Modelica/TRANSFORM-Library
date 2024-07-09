within TRANSFORM.Units.Conversions.Functions.MassFlowRate_kg_s;
function to_klbm_hr "Mass Flow Rate: [kg/s] -> [klbm/hr]"
  extends BaseClasses.to;
algorithm
  y :=to_lbm_hr(u)/1000;
end to_klbm_hr;
