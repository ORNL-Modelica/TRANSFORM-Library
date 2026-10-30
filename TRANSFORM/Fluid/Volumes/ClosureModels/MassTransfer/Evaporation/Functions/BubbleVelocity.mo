within TRANSFORM.Fluid.Volumes.ClosureModels.MassTransfer.Evaporation.Functions;
function BubbleVelocity
  extends Modelica.Icons.ObsoleteModel;
  /*
  Source:
  1. NUREG-CR-4449 pg 30
  */
  input Units.VoidFraction alphaV "Void fraction in liquid region";
  input SI.Density rho_v "Vapor density";
  input SI.Area Ac "Average cross sectional area";
  input SI.Velocity v_bub "Bubble terminal velocity";
  output SI.MassFlowRate m_flow "Mass flow rate";
algorithm
  m_flow :=v_bub*(0.9 + 0.1*alphaV)*rho_v*Ac;
end BubbleVelocity;
