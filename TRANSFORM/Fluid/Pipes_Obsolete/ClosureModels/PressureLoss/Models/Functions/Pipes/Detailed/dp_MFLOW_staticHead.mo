within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.Models.Functions.Pipes.Detailed;
function dp_MFLOW_staticHead "calculate mass flow rate with static head"
  extends Modelica.Icons.Function;

  //input records
  input
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.Models.Functions.Pipes.Detailed.dp_IN_con
    IN_con "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Constant inputs"));
  input
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.Models.Functions.Pipes.Detailed.dp_IN_var
    IN_var "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Variable inputs"));
  input SI.Pressure dp "Pressure loss"
    annotation (Dialog(group="Input"));
  input SI.AbsolutePressure dp_small=1
    "Regularization of zero flow if |dp| < dp_small (dummy if use_dp_small = false)";
  input Real g_times_height_ab
    "Gravity times (Height(port_b) - Height(port_a))";

  //Outputs
  output SI.MassFlowRate M_FLOW "Output of function dp_overall_MFLOW";

protected
    Real diameter = 0.5*(IN_con.diameter_a+IN_con.diameter_b)
    "Average diameter";
    Real roughness = 0.5*(IN_con.roughness_a+IN_con.roughness_b)
    "Average height of surface asperities";
    Real Delta = roughness/diameter "Relative roughness";
    SI.ReynoldsNumber Re "Reynolds number";
    SI.ReynoldsNumber Re1=min((745*exp(if Delta <= 0.0065 then 1
         else 0.0065/Delta))^0.97, IN_con.Re_turbulent)
    "Boundary between laminar regime and transition";
    SI.ReynoldsNumber Re2=IN_con.Re_turbulent
    "Boundary between transition and turbulent regime";
    SI.Pressure dp_a
    "Upper end of regularization domain of the m_flow(dp) relation";
    SI.Pressure dp_b
    "Lower end of regularization domain of the m_flow(dp) relation";
    SI.MassFlowRate m_flow_a "Value at upper end of regularization domain";
    SI.MassFlowRate m_flow_b "Value at lower end of regularization domain";

    SI.MassFlowRate dm_flow_ddp_fric_a
    "Derivative at upper end of regularization domain";
    SI.MassFlowRate dm_flow_ddp_fric_b
    "Derivative at lower end of regularization domain";

    SI.Pressure dp_grav_a=g_times_height_ab*IN_var.rho_a
    "Static head if mass flows in design direction (a to b)";
    SI.Pressure dp_grav_b=g_times_height_ab*IN_var.rho_b
    "Static head if mass flows against design direction (b to a)";

    // Properly define zero mass flow conditions
    SI.MassFlowRate m_flow_zero=0;
    SI.Pressure dp_zero=(dp_grav_a + dp_grav_b)/2;
    Real dm_flow_ddp_fric_zero;

algorithm
    dp_a := max(dp_grav_a, dp_grav_b)+dp_small;
    dp_b := min(dp_grav_a, dp_grav_b)-dp_small;

    if dp>=dp_a then
      // Positive flow outside regularization
      M_FLOW := Internal.m_flow_of_dp_fric(IN_con, IN_var, dp-dp_grav_a, Re1, Re2, Delta);
    elseif dp<=dp_b then
      // Negative flow outside regularization
      M_FLOW := Internal.m_flow_of_dp_fric(IN_con, IN_var, dp-dp_grav_b, Re1, Re2, Delta);
    else
      // Regularization parameters
      (m_flow_a, dm_flow_ddp_fric_a) := Internal.m_flow_of_dp_fric(IN_con, IN_var, dp_a-dp_grav_a, Re1, Re2, Delta);
      (m_flow_b, dm_flow_ddp_fric_b) := Internal.m_flow_of_dp_fric(IN_con, IN_var, dp_b-dp_grav_b, Re1, Re2, Delta);
      // Include a properly defined zero mass flow point
      // Obtain a suitable slope from the linear section slope c (value of m_flow is overwritten later)
      (M_FLOW,dm_flow_ddp_fric_zero) := Modelica.Fluid.Utilities.regFun3(
          dp_zero,
          dp_b,
          dp_a,
          m_flow_b,
          m_flow_a,
          dm_flow_ddp_fric_b,
          dm_flow_ddp_fric_a);
      // Do regularization
      if dp>dp_zero then
        M_FLOW := Modelica.Fluid.Utilities.regFun3(
            dp,
            dp_zero,
            dp_a,
            m_flow_zero,
            m_flow_a,
            dm_flow_ddp_fric_zero,
            dm_flow_ddp_fric_a);
      else
        M_FLOW := Modelica.Fluid.Utilities.regFun3(
            dp,
            dp_b,
            dp_zero,
            m_flow_b,
            m_flow_zero,
            dm_flow_ddp_fric_b,
            dm_flow_ddp_fric_zero);
      end if;
    end if;
    annotation (smoothOrder=1);
end dp_MFLOW_staticHead;
