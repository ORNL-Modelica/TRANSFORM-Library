within TRANSFORM.Units.Conversions.Functions.Density_kg_m3;
function to_lb_ft3 "Density: [kg/m^3] -> [lb/ft^3]"
  extends BaseClasses.to;

algorithm
  y := u/0.453592*(12^3*0.0254^3);
end to_lb_ft3;
