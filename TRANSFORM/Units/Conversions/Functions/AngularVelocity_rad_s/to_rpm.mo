within TRANSFORM.Units.Conversions.Functions.AngularVelocity_rad_s;
function to_rpm "Angular Velocity: [rad/s] -> [rpm]"
  extends BaseClasses.to;
algorithm
  y := u*60/2/Modelica.Constants.pi;
end to_rpm;
