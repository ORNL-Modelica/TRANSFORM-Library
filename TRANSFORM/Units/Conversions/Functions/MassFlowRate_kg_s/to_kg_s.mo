within TRANSFORM.Units.Conversions.Functions.MassFlowRate_kg_s;
function to_kg_s "Mass Flow Rate: [kg/s] -> [kg/s]"
  extends BaseClasses.to;

algorithm
  y := u;
end to_kg_s;
