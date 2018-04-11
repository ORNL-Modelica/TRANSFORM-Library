within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.Window;
function dp_MFLOW "calculate mass flow rate"

  extends Modelica.Icons.Function;

  //input records
  input
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.Window.dp_IN_con
    IN_con "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Constant inputs"));
  input
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.Window.dp_IN_var
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

  Real gamma = 2*Modelica.Math.acos(1 - 2*IN_con.H/IN_con.D_l)*180/pi;

  Real n_MRWtemp = 0.8*IN_con.H/IN_con.s2;
  Real n_MRW = if n_MRWtemp > 2*IN_con.n_RW then 2*IN_con.n_RW else n_MRWtemp;

  SI.Area A_WT = pi/4*IN_con.D_i^2*gamma/360 - (IN_con.D_l-2*IN_con.H)*IN_con.D_l/4*Modelica.Math.sin(gamma/2*pi/180);
  SI.Area A_T = pi/4*IN_con.d_o^2*IN_con.n_W/2;
  SI.Area A_W = A_WT-A_T;

  SI.Length U_W = pi*IN_con.D_i*gamma/360+pi*IN_con.d_o*IN_con.n_W/2;
  SI.Length d_g = 4*A_W/U_W;

  Real f_L=
    Internal.f_L_baffact(
      gamma,
      IN_con.H,
      IN_con.D_l,
      IN_con.D_i,
      IN_con.d_B,
      IN_con.d_o,
      IN_con.n_T,
      IN_con.n_W,
      A_E);

  Real f_zL;
  Real f_zt;
  Real f_z;
  Real lambda_lam;
  Real lambda_turb;

  SI.DynamicViscosity mu "Upstream viscosity";
  SI.Density rho "Upstream density";
  SI.ReynoldsNumber Re "Reynolds number";
  Real lambda2 "Modified friction coefficient (= lambda*Re^2)";
  Real aux1, aux2;

  Real error = 1;
  Real errTol = 1e-3;
  Real iter = 0;
  Real itMax = 10;
  SI.ReynoldsNumber Re_old = 1e4;

algorithm
  // Determine upstream density, upstream viscosity, and lambda2
  rho     := if dp >= 0 then IN_var.rho_a else IN_var.rho_b;
  mu      := if dp >= 0 then IN_var.mu_a else IN_var.mu_b;

  lambda_turb :=0.6*n_MRW + 2;
  aux1:= 2*rho*IN_con.d_o*IN_con.d_o/(mu*mu);

  while error > errTol and iter < itMax loop
    iter := iter + 1;

    (f_zL,f_zt) :=
      Internal.f_LeakFactors(
      Re_old,
      a,
      b,
      mu,
      IN_var.mu_w);

    f_z :=if Re_old < 100 then f_zL else f_zt;

    lambda_lam :=56*IN_con.d_o/(e*Re_old)*n_MRW + 52*IN_con.d_o/(d_g*Re_old)*(IN_con.S/d_g) + 2;

    aux2:= sqrt(lambda_lam*lambda_lam+lambda_turb*lambda_turb)*f_z*f_L;

    lambda2 := abs(dp)*aux1*IN_con.nNodes;

    // Determine Re
    Re := sqrt(lambda2/aux2);

    error := abs(Re - Re_old);
    Re_old := Re;
  end while;

  // Determine mass flow rate
  M_FLOW := mu*sqrt(A_E*A_W)/IN_con.d_o*(if dp >= 0 then Re else -Re);
          annotation (smoothOrder=1, Documentation(info="<html>

</html>"));
end dp_MFLOW;
