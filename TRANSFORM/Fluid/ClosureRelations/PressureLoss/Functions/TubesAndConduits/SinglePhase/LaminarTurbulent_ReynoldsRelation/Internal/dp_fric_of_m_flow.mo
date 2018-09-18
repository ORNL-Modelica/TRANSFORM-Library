within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.LaminarTurbulent_ReynoldsRelation.Internal;
function dp_fric_of_m_flow
  "Calculate pressure drop as a function of mass flow rate"
  extends Modelica.Icons.Function;

  //input records
  input dp_IN_con IN_con "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Constant inputs"));
  input dp_IN_var IN_var "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Variable inputs"));

  input SI.MassFlowRate m_flow "Mass flow rate from port_a to port_b";

  //Outputs
  output SI.Pressure dp_fric
    "Pressure loss due to friction (dp_fric = port_a.p - port_b.p - dp_grav)";
  output Real ddp_fric_dm_flow
    "Derivative of pressure drop with mass flow rate";

protected
  Real diameter = 0.5*(IN_con.diameter_a+IN_con.diameter_b) "Average diameter";
  Real crossArea = 0.5*(IN_con.crossArea_a+IN_con.crossArea_b)
    "Average cross area";
  SI.DynamicViscosity mu "Upstream viscosity";
  SI.Density rho "Upstream density";
  SI.ReynoldsNumber Re "Reynolds number";
  Real fLDplusK_Re2 "Modified loss coefficient";
  Real dfLDplusK_Re2_dm_flow "d/dm_flow";
  Real aux1;

algorithm
  // Determine upstream density and upstream viscosity
  if m_flow >= 0 then
    rho := IN_var.rho_a;
    mu  := IN_var.mu_a;
  else
    rho := IN_var.rho_b;
    mu  := IN_var.mu_b;
  end if;

  // Determine Reynolds number
  Re := abs(m_flow)*diameter/(crossArea*mu);

  aux1 := diameter/(crossArea*mu);

  fLDplusK_Re2 :=IN_con.A*Re^2 + IN_con.B*Re^(2 - IN_con.C);

  dfLDplusK_Re2_dm_flow := 2*IN_con.A*aux1^2*abs(m_flow) + (2-IN_con.C)*IN_con.B*aux1^(2-IN_con.C)*abs(m_flow)^(1-IN_con.C);

  // Compute pressure drop from lambda2
  dp_fric :=mu*mu/(2*rho*diameter*diameter)*
       (if m_flow >= 0 then fLDplusK_Re2 else -fLDplusK_Re2);

  // Compute derivative from dlambda2/dm_flow
  ddp_fric_dm_flow := (mu^2)/(2*diameter^2*rho)*dfLDplusK_Re2_dm_flow;
  annotation(smoothOrder=1);
end dp_fric_of_m_flow;
