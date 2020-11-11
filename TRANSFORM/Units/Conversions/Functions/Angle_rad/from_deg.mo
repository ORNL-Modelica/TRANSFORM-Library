within TRANSFORM.Units.Conversions.Functions.Angle_rad;
function from_deg "Angle: [deg] -> [rad]"
  extends BaseClasses.from;
algorithm
  y := u*2*Modelica.Constants.pi/360;
end from_deg;
