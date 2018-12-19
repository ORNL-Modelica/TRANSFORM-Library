within TRANSFORM.Units.Conversions.Functions.MassFlowRate_kg_s;
function from_kg_s "Mass Flow Rate: [kg/s] -> [kg/s]"
  extends BaseClasses.from;

algorithm
  y := u;
end from_kg_s;
