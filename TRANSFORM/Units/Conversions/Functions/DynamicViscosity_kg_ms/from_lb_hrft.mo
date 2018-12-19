within TRANSFORM.Units.Conversions.Functions.DynamicViscosity_kg_ms;
function from_lb_hrft "Dynamic Viscosity: [lb/(ft*hr)] -> [kg/(m*s)]"
  extends BaseClasses.from;

algorithm
  y := u*0.453592/(12*0.0254*60^2);
end from_lb_hrft;
