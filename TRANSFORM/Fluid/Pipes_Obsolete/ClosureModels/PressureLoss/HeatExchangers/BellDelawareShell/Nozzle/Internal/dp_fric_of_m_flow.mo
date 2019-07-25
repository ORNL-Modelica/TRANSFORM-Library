within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.Nozzle.Internal;
function dp_fric_of_m_flow
  "Calculate pressure drop as a function of mass flow rate"
  extends Modelica.Icons.Function;
  //input records
  input
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.Nozzle.dp_IN_con
    IN_con "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Constant inputs"));
  input
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.Nozzle.dp_IN_var
    IN_var "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate from port_a to port_b";
  //Outputs
  output SI.Pressure dp_fric
    "Pressure loss due to friction (dp_fric = port_a.p - port_b.p - dp_grav)";
  output Real ddp_fric_dm_flow
    "Derivative of pressure drop with mass flow rate";
protected
  Real A_NF = IN_con.d_N*IN_con.d_N/(IN_con.D_i*IN_con.D_i-IN_con.n_T*IN_con.d_o*IN_con.d_o)
    "Cross-sectional area ratio of the nozzle to the free area of the heat exchanger shell";
  Real C_InOut "Constant for inlet vs outlet flow";
  SI.DynamicViscosity mu "Upstream viscosity";
  SI.Density rho "Upstream density";
  SI.ReynoldsNumber Re "Reynolds number";
  Real lambda2 "Modified friction coefficient (= lambda*Re^2)";
  Real dlambda2_dm_flow "dlambda2/dm_flow";
  Real aux1;
  Real aux2;
algorithm
  // Determine upstream density and upstream viscosity
  rho     :=if m_flow >= 0 then IN_var.rho_a else IN_var.rho_b;
  mu      :=if m_flow >= 0 then IN_var.mu_a else IN_var.mu_b;
  C_InOut :=if m_flow >= 0 then 3.308 else 2.482;
  aux1 := 4/(pi*IN_con.d_N*mu);
  // Determine Reynolds number
  Re := abs(m_flow)*aux1;
  // Use correlation for lambda2 depending on actual conditions
  lambda2 :=Re*Re*aux2;
  dlambda2_dm_flow := 2*Re*aux1*aux2;
  // Compute pressure drop from lambda2
  dp_fric := mu*mu/(2*rho*IN_con.d_N*IN_con.d_N*IN_con.nNodes)*(if m_flow >= 0 then lambda2 else -lambda2);
  // Compute derivative from dlambda2/dm_flow
  ddp_fric_dm_flow := mu*mu/(2*rho*IN_con.d_N*IN_con.d_N*IN_con.nNodes)*dlambda2_dm_flow;
  annotation(smoothOrder=1);
end dp_fric_of_m_flow;
