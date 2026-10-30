within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Functions.Monitoring;
function assertPositiveDifference
  extends Modelica.Icons.Function;
  input SI.Pressure p;
  input SI.Pressure p_sat;
  input String message;
  output SI.Pressure dp;
algorithm
  dp := p - p_sat;
  assert(p >= p_sat, message);
end assertPositiveDifference;
