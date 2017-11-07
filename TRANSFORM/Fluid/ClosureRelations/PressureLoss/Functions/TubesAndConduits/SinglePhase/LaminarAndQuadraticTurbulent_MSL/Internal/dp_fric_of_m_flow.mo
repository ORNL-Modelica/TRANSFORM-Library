within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.LaminarAndQuadraticTurbulent_MSL.Internal;
function dp_fric_of_m_flow
  "Calculate pressure drop due to friction as function of mass flow rate"
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

  //output variables
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
  Real zeta;
  Real k0;
  Real k;
  Real ddp_fric_dm_flow_laminar
    "Derivative of dp_fric = f(m_flow) at zero";
  SI.MassFlowRate m_flow_turbulent
    "The turbulent region is: |m_flow| >= m_flow_turbulent";
  SI.MassFlowRate m_flow_laminar
    "The laminar region is: |m_flow| <= m_flow_laminar";
algorithm
/*
Turbulent region:
   Re = m_flow*(4/pi)/(D_Re*mu)
   dp = 0.5*zeta*rho*v*|v|
      = 0.5*zeta*rho*1/(rho*A)^2 * m_flow * |m_flow|
      = 0.5*zeta/A^2 *1/rho * m_flow * |m_flow|
      = k/rho * m_flow * |m_flow|
   k  = 0.5*zeta/A^2
      = 0.5*zeta/(pi*(D/2)^2)^2
      = 8*zeta/(pi*D^2)^2
   m_flow_turbulent = (pi/4)*D_Re*mu*Re_turbulent

Laminar region:
   dp = 0.5*zeta/(A^2*d) * m_flow * |m_flow|
      = 0.5 * c0/(|m_flow|*(4/pi)/(D_Re*mu)) / ((pi*(D_Re/2)^2)^2*d) * m_flow*|m_flow|
      = 0.5 * c0*(pi/4)*(D_Re*mu) * 16/(pi^2*D_Re^4*d) * m_flow*|m_flow|
      = 2*c0/(pi*D_Re^3) * mu/rho * m_flow
      = k0 * mu/rho * m_flow
   k0 = 2*c0/(pi*D_Re^3)
*/
  // Determine upstream density and upstream viscosity
  if m_flow >= 0 then
    rho := IN_var.rho_a;
    mu  := IN_var.mu_a;
  else
    rho := IN_var.rho_b;
    mu  := IN_var.mu_b;
  end if;

  // Turbulent
  // WARNING: The following equations are only correct for circular tubes!
  zeta := (IN_con.length/diameter)/(2*log10(3.7/(Delta)))^2;
  k := 8*zeta/(pi*diameter*diameter)^2;
  m_flow_turbulent := sign(m_flow)*(pi/4)*diameter*mu*Re2;

  // Laminar
  k0 := 128*IN_con.length/(pi*diameter^4);
  ddp_fric_dm_flow_laminar := k0*mu/rho;
  m_flow_laminar := sign(m_flow)*(pi/4)*diameter*mu*Re1;

  if abs(m_flow) > abs(m_flow_turbulent) then
    dp_fric := k/rho*m_flow*abs(m_flow);
    ddp_fric_dm_flow := 2*k/rho*abs(m_flow);
  elseif abs(m_flow) < abs(m_flow_laminar) then
    dp_fric := ddp_fric_dm_flow_laminar*m_flow;
    ddp_fric_dm_flow := ddp_fric_dm_flow_laminar;
  else
    // Preliminary testing seems to indicate that the log-log transform is not required here
    (dp_fric,ddp_fric_dm_flow) :=
      Modelica.Fluid.Utilities.cubicHermite_withDerivative(
      m_flow,
      m_flow_laminar,
      m_flow_turbulent,
      ddp_fric_dm_flow_laminar*m_flow_laminar,
      k/rho*m_flow_turbulent*abs(m_flow_turbulent),
      ddp_fric_dm_flow_laminar,
      2*k/rho*abs(m_flow_turbulent));
  end if;
  annotation (smoothOrder=1);
end dp_fric_of_m_flow;
