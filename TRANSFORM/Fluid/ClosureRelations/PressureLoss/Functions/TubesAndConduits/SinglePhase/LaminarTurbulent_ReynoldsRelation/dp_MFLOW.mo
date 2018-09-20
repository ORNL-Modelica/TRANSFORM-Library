within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.LaminarTurbulent_ReynoldsRelation;
function dp_MFLOW "calculate mass flow rate"

  import Modelica.Constants.pi;
  import Modelica.Math;

  extends Modelica.Icons.Function;

  //input records
  input dp_IN_con IN_con "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Constant inputs"));
  input dp_IN_var IN_var "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Variable inputs"));
  input SI.Pressure dp "Pressure loss" annotation (Dialog(group="Input"));
  input SI.AbsolutePressure dp_small=1
    "Regularization of zero flow if |dp| < dp_small (dummy if use_dp_small = false)";

  //Outputs
  output SI.MassFlowRate M_FLOW "Output of function dp_overall_MFLOW";

protected
  Real diameter=0.5*(IN_con.diameter_a + IN_con.diameter_b) "Average diameter";
  Real crossArea=0.5*(IN_con.crossArea_a + IN_con.crossArea_b)
    "Average cross area";

  SI.DynamicViscosity mu "Upstream viscosity";
  SI.Density rho "Upstream density";
  SI.ReynoldsNumber Re "Reynolds number";
  Real fLDplusK "Loss coefficient";

algorithm
  // Determine upstream density, upstream viscosity, and lambda2
  rho := if dp >= 0 then IN_var.rho_a else IN_var.rho_b;
  mu := if dp >= 0 then IN_var.mu_a else IN_var.mu_b;
  fLDplusK := abs(dp)*2*diameter*diameter*rho/(mu*mu);

  // Determine Re under the assumption of laminar flow
  Re := ((fLDplusK - IN_con.A)/IN_con.B)^(-1/IN_con.C);

  // Determine mass flow rate
  M_FLOW := crossArea/diameter*mu*(if dp >= 0 then Re else -Re);
  annotation (smoothOrder=1, Documentation(info="<html>

</html>"));
end dp_MFLOW;
