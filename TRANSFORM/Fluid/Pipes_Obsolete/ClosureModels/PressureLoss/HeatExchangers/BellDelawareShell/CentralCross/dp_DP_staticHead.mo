within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.CentralCross;
function dp_DP_staticHead "calculate pressure loss  with static head"
  extends Modelica.Icons.Function;

  //input records
  input
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.CentralCross.dp_IN_con
    IN_con "Input record for function dp_overall_DP"
    annotation (Dialog(group="Constant inputs"));
  input
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.CentralCross.dp_IN_var
    IN_var "Input record for function dp_overall_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));
  input SI.MassFlowRate m_flow_small=0.01
    "Regularization of zero flow if |m_flow| < m_flow_small (dummy if use_m_flow_small = false)";
  input Real g_times_height_ab
    "Gravity times (Height(port_b) - Height(port_a))";

  //Outputs
  output SI.Pressure DP "Output for function dp_overall_DP";

protected
  SI.MassFlowRate m_flow_a
    "Upper end of regularization domain of the dp(m_flow) relation";
  SI.MassFlowRate m_flow_b
    "Lower end of regularization domain of the dp(m_flow) relation";

  SI.Pressure dp_a "Value at upper end of regularization domain";
  SI.Pressure dp_b "Value at lower end of regularization domain";

  SI.Pressure dp_grav_a=g_times_height_ab*IN_var.rho_a
    "Static head if mass flows in design direction (a to b)";
  SI.Pressure dp_grav_b=g_times_height_ab*IN_var.rho_b
    "Static head if mass flows against design direction (b to a)";

  Real ddp_dm_flow_a
    "Derivative of pressure drop with mass flow rate at m_flow_a";
  Real ddp_dm_flow_b
    "Derivative of pressure drop with mass flow rate at m_flow_b";

  // Properly define zero mass flow conditions
  SI.MassFlowRate m_flow_zero=0;
  SI.Pressure dp_zero=(dp_grav_a + dp_grav_b)/2;
  Real ddp_dm_flow_zero;

algorithm
  m_flow_a := if dp_grav_a<dp_grav_b then
    Internal.m_flow_of_dp_fric(IN_con, IN_var, dp_grav_b - dp_grav_a)+m_flow_small else
    m_flow_small;
  m_flow_b := if dp_grav_a<dp_grav_b then
    Internal.m_flow_of_dp_fric(IN_con, IN_var, dp_grav_a - dp_grav_b)-m_flow_small else
    -m_flow_small;

  if m_flow>=m_flow_a then
    // Positive flow outside regularization
    DP := Internal.dp_fric_of_m_flow(IN_con, IN_var, m_flow) + dp_grav_a;
  elseif m_flow<=m_flow_b then
    // Negative flow outside regularization
    DP := Internal.dp_fric_of_m_flow(IN_con, IN_var, m_flow) + dp_grav_b;
  else
    // Regularization parameters
    (dp_a, ddp_dm_flow_a) := Internal.dp_fric_of_m_flow(IN_con, IN_var, m_flow_a);
    dp_a := dp_a + dp_grav_a "Adding dp_grav to dp_fric to get dp";
    (dp_b, ddp_dm_flow_b) := Internal.dp_fric_of_m_flow(IN_con, IN_var, m_flow_b);
    dp_b := dp_b + dp_grav_b "Adding dp_grav to dp_fric to get dp";
    // Include a properly defined zero mass flow point
    // Obtain a suitable slope from the linear section slope c (value of dp is overwritten later)
    (DP,ddp_dm_flow_zero) := Modelica.Fluid.Utilities.regFun3(
        m_flow_zero,
        m_flow_b,
        m_flow_a,
        dp_b,
        dp_a,
        ddp_dm_flow_b,
        ddp_dm_flow_a);
    // Do regularization
    if m_flow>m_flow_zero then
      DP := Modelica.Fluid.Utilities.regFun3(
          m_flow,
          m_flow_zero,
          m_flow_a,
          dp_zero,
          dp_a,
          ddp_dm_flow_zero,
          ddp_dm_flow_a);
    else
      DP := Modelica.Fluid.Utilities.regFun3(
          m_flow,
          m_flow_b,
          m_flow_zero,
          dp_b,
          dp_zero,
          ddp_dm_flow_b,
          ddp_dm_flow_zero);
    end if;
  end if;
  annotation (smoothOrder=1);
end dp_DP_staticHead;
