within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.TwoPhase.LaminarTurbulent_MSLDetailed.Internal;
function dp_fric_of_m_flow
  "Calculate pressure drop as a function of mass flow rate"
  extends Modelica.Icons.Function;
  //input records
  input dp_IN_con IN_con "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Constant inputs"));
  input dp_IN_var IN_var "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Variable inputs"));
  input SI.MassFlowRate m_flow "Mass flow rate from port_a to port_b";
  input SI.ReynoldsNumber Re1 "Boundary between laminar regime and transition";
  input SI.ReynoldsNumber Re2
    "Boundary between transition and turbulent regime";
  input Real Delta "Relative IN_con.roughness";
  //Outputs
  output SI.Pressure dp_fric
    "Pressure loss due to friction (dp_fric = port_a.p - port_b.p - dp_grav)";
  output Real ddp_fric_dm_flow
    "Derivative of pressure drop with mass flow rate";
protected
  function interpolateInRegion2
    "Interpolation in log-log space using a cubic Hermite polynomial, where x=log10(Re), y=log10(lambda2)"
    input SI.ReynoldsNumber Re "Known independent variable";
    input SI.ReynoldsNumber Re1
      "Boundary between laminar regime and transition";
    input SI.ReynoldsNumber Re2
      "Boundary between transition and turbulent regime";
    input Real Delta "Relative IN_con.roughness";
    input SI.MassFlowRate m_flow "Mass flow rate from port_a to port_b";
    output Real lambda2 "Unknown return value";
    output Real dlambda2_dm_flow "Derivative of return value";
    // point lg(lambda2(Re1)) with derivative at lg(Re1)
  protected
    Real x1 = Modelica.Math.log10(
                    Re1);
    Real y1 = Modelica.Math.log10(
                    64*Re1);
    Real y1d = 1;
    // Point lg(lambda2(Re2)) with derivative at lg(Re2)
    Real aux2 = Delta/3.7 + 5.74/Re2^0.9;
    Real aux3 = Modelica.Math.log10(
                      aux2);
    Real L2 = 0.25*(Re2/aux3)^2;
    Real x2 = Modelica.Math.log10(
                    Re2);
    Real y2 = Modelica.Math.log10(
                    L2);
    Real y2d = 2+(2*5.74*0.9)/(log(aux2)*Re2^0.9*aux2);
    // Point of interest in transformed space
    Real x=Modelica.Math.log10(
                 Re);
    Real y;
    Real dy_dx "Derivative in transformed space";
  algorithm
    // Interpolation
    (y,dy_dx) := Modelica.Fluid.Utilities.cubicHermite_withDerivative(
        x,
        x1,
        x2,
        y1,
        y2,
        y1d,
        y2d);
    // Return value
    lambda2 := 10^y;
    // Derivative of return value
    dlambda2_dm_flow := lambda2/abs(m_flow)*dy_dx;
    annotation(smoothOrder=1);
  end interpolateInRegion2;
  Real diameter = 0.5*(IN_con.diameter_a+IN_con.diameter_b) "Average diameter";
  Real crossArea = 0.5*(IN_con.crossArea_a+IN_con.crossArea_b)
    "Average cross area";
  SI.DynamicViscosity mu "Upstream viscosity";
  SI.Density rho "Upstream density";
  SI.ReynoldsNumber Re "Reynolds number";
  Real lambda2 "Modified friction coefficient (= lambda*Re^2)";
  Real dlambda2_dm_flow "dlambda2/dm_flow";
  Real aux1;
  Real aux2;
  SI.DynamicViscosity mu_lsat "Upstream liquid viscosity";
  SI.Density rho_lsat "Upstream liquid density";
  SI.DynamicViscosity mu_vsat "Upstream vapor viscosity";
  SI.Density rho_vsat "Upstream vapor density";
  SIadd.NonDim x_abs "Upstream absolute quality";
  Real phi2 "Two-phase modifier";
algorithm
  // Determine upstream density and upstream viscosity
  if m_flow >= 0 then
    rho := IN_var.rho_a;
    mu  := IN_var.mu_a;
    rho_lsat := IN_var.rho_lsat_a;
    mu_lsat  := IN_var.mu_lsat_a;
    rho_vsat := IN_var.rho_vsat_a;
    mu_vsat  := IN_var.mu_vsat_a;
    x_abs := IN_var.x_abs_a;
  else
    rho := IN_var.rho_b;
    mu  := IN_var.mu_b;
    rho_lsat := IN_var.rho_lsat_b;
    mu_lsat  := IN_var.mu_lsat_b;
    rho_vsat := IN_var.rho_vsat_b;
    mu_vsat  := IN_var.mu_vsat_b;
    x_abs := IN_var.x_abs_b;
  end if;
  phi2 := TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.Utilities.TwoPhaseFrictionMultiplier(x_abs,mu_lsat,mu_vsat,rho_lsat,rho_vsat);
  // Determine Reynolds number
  Re := abs(m_flow)*diameter/(crossArea*mu);
  aux1 := diameter/(crossArea*mu);
  // Use correlation for lambda2 depending on actual conditions
  if Re <= Re1 then
    lambda2 := 64*Re "Hagen-Poiseuille";
    dlambda2_dm_flow := 64*aux1 "Hagen-Poiseuille";
  elseif Re >= Re2 then
    lambda2 := 0.25*(Re/Modelica.Math.log10(Delta/3.7 + 5.74/Re^0.9))^2
      "Swamee-Jain";
    aux2 := Delta/3.7+5.74/((aux1*abs(m_flow))^0.9);
    dlambda2_dm_flow := 0.5*aux1*Re*log(10)^2*(1/(log(aux2)^2)+(5.74*0.9)/(log(aux2)^3*Re^0.9*aux2))
      "Swamee-Jain";
  else
    (lambda2, dlambda2_dm_flow) := interpolateInRegion2(Re, Re1, Re2, Delta, m_flow);
  end if;
  // Compute pressure drop from lambda2
  dp_fric :=IN_con.length*mu*mu/(2*rho*diameter*diameter*diameter)*phi2*
       (if m_flow >= 0 then lambda2 else -lambda2);
  // Compute derivative from dlambda2/dm_flow
  ddp_fric_dm_flow := (IN_con.length*mu^2)/(2*diameter^3*rho)*dlambda2_dm_flow*phi2;
  annotation(smoothOrder=1);
end dp_fric_of_m_flow;
