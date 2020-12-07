within TRANSFORM.Units.Conversions.Functions.AngularVelocity_rad_s;
function to_rpm "Angular Velocity: [rad/s] -> [rpm]"
  extends BaseClasses.from;
algorithm
  y := u/(2*Modelica.Constants.pi/60);
end to_rpm;
