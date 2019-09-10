within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.FlowModels;
partial model PartialGenericPipeFlow
// Constants to be set in subpackages
  constant Boolean use_mu = true
    "= true, if mu_a/mu_b are used in function, otherwise value is not used";
  constant Boolean use_roughness = true
    "= true, if roughness is used in function, otherwise value is not used";
  constant Boolean use_dp_small = true
    "= true, if dp_small is used in function, otherwise value is not used";
  constant Boolean use_m_flow_small = true
    "= true, if m_flow_small is used in function, otherwise value is not used";
  constant Boolean dp_is_zero = false
    "= true, if no wall friction is present, i.e., dp = 0 (function massFlowRate_dp() cannot be used)";
  constant Boolean use_Re_turbulent = true
    "= true, if Re_turbulent input is used in function, otherwise value is not used";
  parameter Boolean from_dp = momentumDynamics >=Modelica.Fluid.Types.Dynamics.SteadyStateInitial
    "= true, use m_flow = f(dp), otherwise dp = f(m_flow)"
    annotation (Dialog(group="Advanced"), Evaluate=true);
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.FlowModels.PartialStaggeredFlowModel;
  // Parameters
  parameter SI.AbsolutePressure dp_nominal(start=1, fixed=false)
    "Nominal pressure loss (only for nominal models)";
  parameter SI.MassFlowRate m_flow_nominal= if system.use_eps_Re then system.m_flow_nominal else 1e2*m_flow_small
    "Nominal mass flow rate";
  parameter SI.MassFlowRate m_flow_small=if system.use_eps_Re
       then system.eps_m_flow*m_flow_nominal else system.m_flow_small
    "Within regularization if |m_flows| < m_flow_small (may be wider for large discontinuities in static head)"
    annotation (Dialog(enable=not from_dp and use_m_flow_small));
  parameter SI.Temperature Ts_w_nominal = Medium.temperature(
      Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default))
    "Nominal temperature";
end PartialGenericPipeFlow;
