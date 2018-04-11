within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.CentralCross;
function dp_DP "calculate pressure loss"

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

  //Outputs
  output SI.Pressure DP "Output for function dp_overall_DP";

protected
  Real a = IN_con.s1/IN_con.d_B;
  Real b = IN_con.s2/IN_con.d_B;
  Real c = ((a/2)^2 + b^2)^(0.5);

  SI.Length e = (if IN_con.toggleStaggered then
                  (if b >= 0.5*(2*a+1)^(0.5) then (a - 1)*IN_con.d_B else (c - 1)*IN_con.d_B)
               else (a - 1)*IN_con.d_B);
  SI.Length L_E = 2*IN_con.e1 + e*IN_con.nes;
  SI.Area A_E = IN_con.S*L_E;

  Real gamma = 2*Modelica.Math.acos(1 - 2*IN_con.H/IN_con.D_l)*180/pi;

  Real f_L=
    Internal.f_L_baffact(
      gamma,
      IN_con.H,
      IN_con.D_l,
      IN_con.D_i,
      IN_con.d_B,
      IN_con.d_B,
      IN_con.n_T,
      IN_con.n_W,
      A_E);

  SI.Area A_B = if e<(IN_con.D_i-IN_con.DB) then IN_con.S*(IN_con.D_i-IN_con.DB-e) else 0;

  Real R_B = A_B/A_E;
  Real R_S = IN_con.n_s/IN_con.n_MR;
  Real beta;
  Real f_B;
  Real f_zL;
  Real f_zt;
  Real epsilon;

  SI.DynamicViscosity mu "Upstream viscosity";
  SI.Density rho "Upstream density";
  SI.ReynoldsNumber Re "Reynolds number";
  Real lambda2 "Modified friction coefficient (= lambda*Re^2)";

algorithm
  // Determine upstream density, upstream viscosity
  rho     :=if m_flow >= 0 then IN_var.rho_a else IN_var.rho_b;
  mu      :=if m_flow >= 0 then IN_var.mu_a else IN_var.mu_b;

  // Determine Re, lambda2 and pressure drop
  Re := IN_con.d_B*abs(m_flow)/(mu*A_E);

  beta :=if Re < 100 then 4.5 else 3.7;

  if R_S == 0 then
    f_B :=exp(-beta*R_B);
  elseif R_S < 0.5 then
    f_B := exp(-beta*R_B*(1 - (2*R_S)^(1/3)));
  else
    f_B := 1;
  end if;

  (f_zL,f_zt) :=
    Internal.f_LeakFactors(
      Re,
      a,
      b,
      mu,
      IN_var.mu_w);

  (epsilon) :=
    Internal.DragCoeff(
      IN_con.toggleStaggered,
      Re,
      a,
      b,
      c,
      f_zL,
      f_zt,
      1,
      1,
      1);

  lambda2 := Re*Re*epsilon*IN_con.n_MR*f_L*f_B;
  DP := mu*mu/(2*rho*IN_con.d_B*IN_con.d_B*IN_con.nNodes)*(if m_flow >= 0 then lambda2 else -lambda2);
          annotation (smoothOrder=1, Documentation(info="<html>

</html>"));
end dp_DP;
