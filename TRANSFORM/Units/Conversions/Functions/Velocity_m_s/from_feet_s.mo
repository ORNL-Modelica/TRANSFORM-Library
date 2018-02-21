within TRANSFORM.Units.Conversions.Functions.Velocity_m_s;
function from_feet_s "Velocity: [ft/s] -> [m/s]"
  extends BaseClasses.from;

algorithm
  y := u*12*0.0254;
end from_feet_s;
