within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.LaminarAndQuadraticTurbulent_MSL;
function dp_DP
  "Return pressure loss dp as function of mass flow rate m_flow, i.e., dp = f(m_flow), due to wall friction"
  import Modelica.Math.log10;
  import Modelica.Constants.pi;

  extends Modelica.Icons.Function;

   //input records
   input dp_IN_con IN_con "Input record for function dp_overall_DP"
     annotation (Dialog(group="Constant inputs"));
   input dp_IN_var IN_var "Input record for function dp_overall_DP"
     annotation (Dialog(group="Variable inputs"));
   input SI.MassFlowRate m_flow "Mass flow rate (positive is port_a to port_b)"
     annotation (Dialog(group="Input"));
   input SI.MassFlowRate m_flow_small=0.01
     "Regularization of zero flow if |m_flow| < m_flow_small (dummy if use_m_flow_small = false)";

   //output variables
   output SI.Pressure DP "Output for function dp_overall_DP";

protected
  SI.Length diameter = 0.5*(IN_con.diameter_a+IN_con.diameter_b);
  SI.Area crossArea = 0.5*(IN_con.crossArea_a+IN_con.crossArea_b);
  SI.Height roughness = 0.5*(IN_con.roughness_a+IN_con.roughness_b);
  SI.ReynoldsNumber Re_turbulent = 4000 "Turbulent flow if Re >= Re_turbulent";

  Real zeta;
  Real k0;
  Real k;
  Real yd0 "Derivative of dp = f(m_flow) at zero";
  SI.MassFlowRate m_flow_turbulent
    "The turbulent region is: |m_flow| >= m_flow_turbulent";

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
   dp_turbulent     =  k/rho *(D_Re*mu*pi/4)^2 * Re_turbulent^2

   The start of the turbulent region is computed with mean values
   of dynamic viscosity mu and density rho. Otherwise, one has
   to introduce different "delta" values for both flow directions.
   In order to simplify the approach, only one delta is used.

Laminar region:
   dp = 0.5*zeta/(A^2*d) * m_flow * |m_flow|
      = 0.5 * c0/(|m_flow|*(4/pi)/(D_Re*mu)) / ((pi*(D_Re/2)^2)^2*d) * m_flow*|m_flow|
      = 0.5 * c0*(pi/4)*(D_Re*mu) * 16/(pi^2*D_Re^4*d) * m_flow*|m_flow|
      = 2*c0/(pi*D_Re^3) * mu/rho * m_flow
      = k0 * mu/rho * m_flow
   k0 = 2*c0/(pi*D_Re^3)

   In order that the derivative of dp=f(m_flow) is continuous
   at m_flow=0, the mean values of mu and d are used in the
   laminar region: mu/rho = (mu_a + mu_b)/(rho_a + rho_b)
*/
  assert(roughness > 1e-10,
         "roughness > 0 required for quadratic turbulent wall friction characteristic");
  // WARNING: The following equations are only correct for circular tubes!
  zeta := (IN_con.length/diameter)/(2*log10(3.7 /(roughness/diameter)))^2;
  k0   := 128*IN_con.length/(pi*diameter^4);
  k    := 8*zeta/(pi*diameter*diameter)^2;
  yd0  := k0*(IN_var.mu_a + IN_var.mu_b)/(IN_var.rho_a + IN_var.rho_b);
  m_flow_turbulent := max((pi/8)*diameter*(IN_var.mu_a + IN_var.mu_b)*Re_turbulent, m_flow_small);
  DP :=Modelica.Fluid.Utilities.regSquare2(m_flow, m_flow_turbulent, k/IN_var.rho_a, k/IN_var.rho_b,
                                           use_yd0=true, yd0=yd0);
  annotation (smoothOrder=1, Documentation(info="<html>

</html>"));
end dp_DP;
