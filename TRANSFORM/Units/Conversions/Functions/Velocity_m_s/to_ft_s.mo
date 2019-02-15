within TRANSFORM.Units.Conversions.Functions.Velocity_m_s;
function to_ft_s "Velocity: [m/s] -> [ft/s]"
  extends BaseClasses.to;
algorithm
  y := u/12/0.0254;
end to_ft_s;
