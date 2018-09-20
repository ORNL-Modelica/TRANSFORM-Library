within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.LaminarTurbulent_ReynoldsRelation;
function dp_DP "calculate pressure loss"

  import Modelica.Constants.pi;
  import Modelica.Math;

  extends Modelica.Icons.Function;

  //input records
  input dp_IN_con IN_con "Input record for function dp_overall_DP"
    annotation (Dialog(group="Constant inputs"));
  input dp_IN_var IN_var "Input record for function dp_overall_DP"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate"
    annotation (Dialog(group="Input"));
  input SI.MassFlowRate m_flow_small=0.01
    "Regularization of zero flow if |m_flow| < m_flow_small (dummy if use_m_flow_small = false)";

  //Outputs
  output SI.Pressure DP "Output for function dp_overall_DP";

protected
  Real diameter = 0.5*(IN_con.diameter_a+IN_con.diameter_b) "Average diameter";
  Real crossArea = 0.5*(IN_con.crossArea_a+IN_con.crossArea_b)
    "Average cross area";

  SI.DynamicViscosity mu "Upstream viscosity";
  SI.Density rho "Upstream density";
  SI.ReynoldsNumber Re "Reynolds number";
  Real fLDplusK_Re2 "Modified loss coefficient";

algorithm
  // Determine upstream density and upstream viscosity
  rho     :=if m_flow >= 0 then IN_var.rho_a else IN_var.rho_b;
  mu      :=if m_flow >= 0 then IN_var.mu_a else IN_var.mu_b;

  // Determine Re, lambda2 and pressure drop
  Re := diameter*abs(m_flow)/(crossArea*mu);

  fLDplusK_Re2 :=IN_con.A*Re^2 + IN_con.B*Re^(2 - IN_con.C);

  DP :=mu*mu/(2*rho*diameter*diameter)*
       (if m_flow >= 0 then fLDplusK_Re2 else -fLDplusK_Re2);

          annotation (smoothOrder=1, Documentation(info="<html>

</html>"));
end dp_DP;
