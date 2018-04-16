within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.Nozzle;
function dp_DP "calculate pressure loss"

  extends Modelica.Icons.Function;

  //input records
  input
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.Nozzle.dp_IN_con
    IN_con "Input record for function dp_overall_DP"
    annotation (Dialog(group="Constant inputs"));
  input
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.Nozzle.dp_IN_var
    IN_var "Input record for function dp_overall_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));
  input SI.MassFlowRate m_flow_small=0.01
    "Regularization of zero flow if |m_flow| < m_flow_small (dummy if use_m_flow_small = false)";

  //Outputs
  output SI.Pressure DP "Output for function dp_overall_DP";

protected
  Real A_NF = IN_con.d_N*IN_con.d_N/(IN_con.D_i*IN_con.D_i-IN_con.n_T*IN_con.d_o*IN_con.d_o)
    "Cross-sectional area ratio of the nozzle to the free area of the heat exchanger shell";
  Real C_InOut "Constant for inlet vs outlet flow";
  SI.DynamicViscosity mu "Upstream viscosity";
  SI.Density rho "Upstream density";
  SI.ReynoldsNumber Re "Reynolds number";
  Real lambda2 "Modified friction coefficient (= lambda*Re^2)";

algorithm
  // Determine upstream density, upstream viscosity, and nozzle type
  rho     :=if m_flow >= 0 then IN_var.rho_a else IN_var.rho_b;
  mu      :=if m_flow >= 0 then IN_var.mu_a else IN_var.mu_b;
  C_InOut :=if m_flow >= 0 then 3.308 else 2.482;

  // Determine Re, lambda2 and pressure drop
  Re := (4/pi)*abs(m_flow)/(IN_con.d_N*mu);
  lambda2 := Re*Re*C_InOut*A_NF^(1.14)*(IN_con.d_N/IN_con.D_i)*(IN_con.D_BE/IN_con.d_N)^(2.4);
  DP := mu*mu/(2*rho*IN_con.d_N*IN_con.d_N*IN_con.nNodes)*(if m_flow >= 0 then lambda2 else -lambda2);
          annotation (smoothOrder=1, Documentation(info="<html>

</html>"));
end dp_DP;
