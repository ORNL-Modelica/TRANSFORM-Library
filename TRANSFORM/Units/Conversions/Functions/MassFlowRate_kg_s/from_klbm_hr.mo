within TRANSFORM.Units.Conversions.Functions.MassFlowRate_kg_s;
function from_klbm_hr "Mass Flow Rate: [klbm/hr] -> [kg/s]"
  extends BaseClasses.from;
algorithm
  y := from_lbm_hr(u)*1000;
end from_klbm_hr;
