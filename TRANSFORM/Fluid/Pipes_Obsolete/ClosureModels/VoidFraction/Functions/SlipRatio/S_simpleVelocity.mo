within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.VoidFraction.Functions.SlipRatio;
function S_simpleVelocity "Simple velocity slip ratio"

  extends Modelica.Icons.Function;

  input SI.Velocity v_p "Primary phase velocity (e.g., liquid velocity)";
  input SI.Velocity v_s "Secondary phase velocity (e.g., vapor velocity)";

  output Units.nonDim S "Slip ratio";

algorithm
  assert(v_p > 0.0, "Primary phase velocity must be greater than 0");

  S :=v_s/v_p;

end S_simpleVelocity;
