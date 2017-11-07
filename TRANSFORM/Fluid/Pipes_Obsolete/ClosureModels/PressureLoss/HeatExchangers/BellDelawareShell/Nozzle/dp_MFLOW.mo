within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PressureLoss.HeatExchangers.BellDelawareShell.Nozzle;
function dp_MFLOW "calculate mass flow rate"

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
  input SI.Pressure dp "Pressure loss"
    annotation (Dialog(group="Input"));
  input SI.AbsolutePressure dp_small=1
    "Regularization of zero flow if |dp| < dp_small (dummy if use_dp_small = false)";

  //output variables
  output SI.MassFlowRate M_FLOW "Output of function dp_overall_MFLOW";

protected
  Real A_NF = IN_con.d_N*IN_con.d_N/(IN_con.D_i*IN_con.D_i-IN_con.n_T*IN_con.d_o*IN_con.d_o)
    "Cross-sectional area ratio of the nozzle to the free area of the heat exchanger shell";
  Real C_InOut "Constant for inlet vs outlet flow";
  SI.DynamicViscosity mu "Upstream viscosity";
  SI.Density rho "Upstream density";
  SI.ReynoldsNumber Re "Reynolds number";
  Real lambda2 "Modified friction coefficient (= lambda*Re^2)";
  Real aux1, aux2;

algorithm
  // Determine upstream density, upstream viscosity, and lambda2
  rho     := if dp >= 0 then IN_var.rho_a else IN_var.rho_b;
  mu      := if dp >= 0 then IN_var.mu_a else IN_var.mu_b;
  C_InOut := if dp >= 0 then 3.308 else 2.482;

  aux1:= 2*rho*IN_con.d_N*IN_con.d_N/(mu*mu);
  aux2:= C_InOut*A_NF^(1.14)*(IN_con.d_N/IN_con.D_i)*(IN_con.D_BE/IN_con.d_N)^(2.4);

  lambda2 := abs(dp)*aux1*IN_con.nNodes;

  // Determine Re
  Re := sqrt(lambda2/aux2);

  // Determine mass flow rate
  M_FLOW := (pi/4)*IN_con.d_N*mu*(if dp >= 0 then Re else -Re);
          annotation (smoothOrder=1, Documentation(info="<html>

</html>"));
end dp_MFLOW;
