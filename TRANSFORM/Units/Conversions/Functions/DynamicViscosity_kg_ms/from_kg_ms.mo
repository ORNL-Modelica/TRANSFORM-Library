within TRANSFORM.Units.Conversions.Functions.DynamicViscosity_kg_ms;
function from_kg_ms "Dynamic Viscosity: [kg/(m*s)] -> [kg/(m*s)]"
  extends BaseClasses.from;
algorithm
  y := u;
end from_kg_ms;
