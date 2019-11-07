within TRANSFORM.Units.Conversions.Functions.AngularVelocity_rad_s;
function from_rpm "Angular Velocity: [rpm] -> [rad/s]"
  extends BaseClasses.from;
algorithm
  y := u*2*Modelica.Constants.pi/60;
end from_rpm;
