within TRANSFORM.Units.Conversions.Functions.Force_N;
function from_lbf "Force: [lbf] -> [N]"
  extends BaseClasses.from;
algorithm
  y := u*Modelica.Constants.g_n/2.20462;
end from_lbf;
