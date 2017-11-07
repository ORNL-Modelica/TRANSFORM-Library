within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.Nozzle.Internal;
function m_flow_of_dp_fric
  "Calculate mass flow rate as a function of pressure drop"
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

  input SI.Pressure dp_fric
    "Pressure loss due to friction (dp = port_a.p - port_b.p)";

  //output variables
  output SI.MassFlowRate m_flow;
  output Real dm_flow_ddp_fric "Derivative of mass flow rate with dp_fric";

protected
  Real A_NF = IN_con.d_N*IN_con.d_N/(IN_con.D_i*IN_con.D_i-IN_con.n_T*IN_con.d_o*IN_con.d_o)
    "Cross-sectional area ratio of the nozzle to the free area of the heat exchanger shell";
  Real C_InOut "Constant for inlet vs outlet flow";
  SI.DynamicViscosity mu "Upstream viscosity";
  SI.Density rho "Upstream density";
  Real lambda2 "Modified friction coefficient (= lambda*Re^2)";
  SI.ReynoldsNumber Re "Reynolds number";
  Real dRe_ddp "dRe/ddp";
  Real aux1;
  Real aux2;

algorithm
  // Determine upstream density and upstream viscosity
  rho := if dp_fric >= 0 then IN_var.rho_a else IN_var.rho_b;
  mu  := if dp_fric >= 0 then IN_var.mu_a else IN_var.mu_b;
  C_InOut := if dp_fric >= 0 then 3.308 else 2.482;

  aux1:= 2*rho*IN_con.d_N*IN_con.d_N/(mu*mu);
  aux2:= C_InOut*A_NF^(1.14)*(IN_con.d_N/IN_con.D_i)*(IN_con.D_BE/IN_con.d_N)^(2.4);

  // Positive mass flow rate
  lambda2 := abs(dp_fric)*aux1*IN_con.nNodes;

  // Determine Re and dRe/ddp
  Re := sqrt(lambda2/aux2);
  dRe_ddp := 0.5*aux1*IN_con.nNodes/aux2/sqrt(lambda2/aux2);

  // Determine mass flow rate
  m_flow := (pi/4)*IN_con.d_N*mu*(if dp_fric >= 0 then Re else -Re);

  // Determine derivative of mass flow rate with dp_fric
  dm_flow_ddp_fric := (pi/4)*IN_con.d_N*mu*dRe_ddp;
  annotation(smoothOrder=1);
end m_flow_of_dp_fric;
