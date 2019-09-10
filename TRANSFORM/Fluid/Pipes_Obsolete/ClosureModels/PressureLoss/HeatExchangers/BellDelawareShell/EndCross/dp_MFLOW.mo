within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.EndCross;
function dp_MFLOW "calculate mass flow rate"
  extends Modelica.Icons.Function;
  //input records
  input
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.EndCross.dp_IN_con
    IN_con "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Constant inputs"));
  input
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.EndCross.dp_IN_var
    IN_var "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Variable inputs"));
  input SI.Pressure dp "Pressure loss"
    annotation (Dialog(group="Input"));
  input SI.AbsolutePressure dp_small=1
    "Regularization of zero flow if |dp| < dp_small (dummy if use_dp_small = false)";
  //Outputs
  output SI.MassFlowRate M_FLOW "Output of function dp_overall_MFLOW";
protected
  Real a = IN_con.s1/IN_con.d_o;
  Real b = IN_con.s2/IN_con.d_o;
  Real c = ((a/2)^2 + b^2)^(0.5);
  SI.Length e = (if IN_con.toggleStaggered then
                  (if b >= 0.5*(2*a+1)^(0.5) then (a - 1)*IN_con.d_o else (c - 1)*IN_con.d_o)
               else (a - 1)*IN_con.d_o);
  SI.Length L_E = 2*IN_con.e1 + e*IN_con.nes;
  SI.Area A_E = IN_con.S*L_E;
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
  Real aux1;
  Real aux2;
  Real error = 1;
  Real errTol = 1e-3;
  Real iter = 0;
  Real itMax = 10;
  SI.ReynoldsNumber Re_old = 1e4;
algorithm
  // Determine upstream density, upstream viscosity, and lambda2
  rho     := if dp >= 0 then IN_var.rho_a else IN_var.rho_b;
  mu      := if dp >= 0 then IN_var.mu_a else IN_var.mu_b;
  aux1:= 2*rho*IN_con.d_o*IN_con.d_o/(mu*mu);
  while error > errTol and iter < itMax loop
    iter := iter + 1;
    beta :=if Re_old < 100 then 4.5 else 3.7;
    if R_S == 0 then
      f_B :=exp(-beta*R_B);
    elseif R_S < 0.5 then
      f_B := exp(-beta*R_B*(1 - (2*R_S)^(1/3)));
    else
      f_B := 1;
    end if;
    (f_zL,f_zt) :=
      Internal.f_LeakFactors(
        Re_old,
        a,
        b,
        mu,
        IN_var.mu_w);
    (epsilon) :=
      Internal.DragCoeff(
        IN_con.toggleStaggered,
        Re_old,
        a,
        b,
        c,
        f_zL,
        f_zt,
        1,
        1,
        1);
    lambda2 := abs(dp)*aux1*IN_con.nNodes;
    aux2 := epsilon*IN_con.n_MRE*f_B;
    // Determine Re
    Re := sqrt(lambda2/aux2);
    error := abs(Re - Re_old);
    Re_old := Re;
  end while;
  // Determine mass flow rate
  M_FLOW := mu*A_E/IN_con.d_o*(IN_con.S_E/IN_con.S)*(if dp >= 0 then Re else -Re);
          annotation (smoothOrder=1, Documentation(info="<html>

</html>"));
end dp_MFLOW;
