within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.LaminarTurbulent_ReynoldsRelation.Internal;
function m_flow_of_dp_fric
  "Calculate mass flow rate as a function of pressure drop"
  extends Modelica.Icons.Function;
  //input records
  input dp_IN_con IN_con "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Constant inputs"));
  input dp_IN_var IN_var "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Variable inputs"));
  input SI.Pressure dp_fric
    "Pressure loss due to friction (dp = port_a.p - port_b.p)";
  //Outputs
  output SI.MassFlowRate m_flow;
  output Real dm_flow_ddp_fric "Derivative of mass flow rate with dp_fric";
protected
  Real diameter = 0.5*(IN_con.diameter_a+IN_con.diameter_b) "Average diameter";
  Real crossArea = 0.5*(IN_con.crossArea_a+IN_con.crossArea_b)
    "Average cross area";
  SI.DynamicViscosity mu "Upstream viscosity";
  SI.Density rho "Upstream density";
  Real fLDplusK "Loss coefficient";
  SI.ReynoldsNumber Re "Reynolds number";
  Real dRe_ddp "dRe/ddp";
  Real aux1;
algorithm
  // Determine upstream density and upstream viscosity
  if dp_fric >= 0 then
    rho := IN_var.rho_a;
    mu  := IN_var.mu_a;
  else
    rho := IN_var.rho_b;
    mu  := IN_var.mu_b;
  end if;
  // Positive mass flow rate
  fLDplusK := abs(dp_fric)*2*diameter*diameter*rho/(mu*mu);
  aux1:=(2*diameter^2*rho)/(mu^2);
  // Determine Re and dRe/ddp under the assumption of laminar flow
  Re := ((fLDplusK-IN_con.A)/IN_con.B)^(-1/IN_con.C);
  dRe_ddp := -aux1/(IN_con.C*IN_con.B)*((fLDplusK-IN_con.A)/IN_con.B)^(-1/IN_con.C-1);
  // Determine mass flow rate
  m_flow := crossArea/diameter*mu*(if dp_fric >= 0 then Re else -Re);
  // Determine derivative of mass flow rate with dp_fric
  dm_flow_ddp_fric := crossArea/diameter*mu*dRe_ddp;
  annotation(smoothOrder=1);
end m_flow_of_dp_fric;
