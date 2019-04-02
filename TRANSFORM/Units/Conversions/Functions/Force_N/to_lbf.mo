within TRANSFORM.Units.Conversions.Functions.Force_N;
function to_lbf "Force: [N] -> [lbf]"
  extends BaseClasses.to;
algorithm
  y := u*2.20462/Modelica.Constants.g_n;
end to_lbf;
