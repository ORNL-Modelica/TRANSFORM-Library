within TRANSFORM.Units.Conversions.Functions.Angle_rad;
function to_deg "Angle: [rad] -> [deg]"
  extends BaseClasses.to;
algorithm
  y := u*360/(2*Modelica.Constants.pi);
end to_deg;
