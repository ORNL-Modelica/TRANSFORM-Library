within TRANSFORM.Units.Conversions.Functions.DynamicViscosity_kg_ms;
function to_lb_hrft
  "Dynamic Viscosity: -> [kg/(m*s)] -> [lb/(ft*hr)]"
  extends BaseClasses.from;
algorithm
  y := u/0.453592*(12*0.0254*60^2);
end to_lb_hrft;
