within TRANSFORM.Fluid.ClosureRelations.PressureLoss.Functions.TubesAndConduits.SinglePhase.LaminarAndQuadraticTurbulent_MSL;
function dp_MFLOW
  "Return mass flow rate m_flow as function of pressure loss dp, i.e., m_flow = f(dp), due to wall friction"
  extends Modelica.Icons.Function;
  //input records
  input dp_IN_con IN_con "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Constant inputs"));
  input dp_IN_var IN_var "Input record for function dp_overall_MFLOW"
    annotation (Dialog(group="Variable inputs"));
  input SI.Pressure dp "Pressure loss (dp = port_a.p - port_b.p)"
    annotation (Dialog(group="Input"));
  input SI.AbsolutePressure dp_small=1
    "Regularization of zero flow if |dp| < dp_small (dummy if use_dp_small = false)";
  //Outputs
  output SI.MassFlowRate M_FLOW "Output of function dp_overall_MFLOW";
protected
  SI.Length diameter = 0.5*(IN_con.diameter_a+IN_con.diameter_b);
  SI.Area crossArea = 0.5*(IN_con.crossArea_a+IN_con.crossArea_b);
  SI.Height roughness = 0.5*(IN_con.roughness_a+IN_con.roughness_b);
  Real zeta;
  Real k0;
  Real k_inv;
  Real yd0 "Derivative of m_flow=m_flow(dp) at zero";
  SI.AbsolutePressure dp_turbulent;
algorithm
/*
Turbulent region:
   // WARNING: The following equations are only correct for circular tubes!
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
   // WARNING: The following equation is only correct for circular tubes!
   dp = 0.5*zeta/(A^2*d) * m_flow * |m_flow|
      = 0.5 * c0/(|m_flow|*(4/pi)/(D_Re*mu)) / ((pi*(D_Re/2)^2)^2*d) * m_flow*|m_flow|
      = 0.5 * c0*(pi/4)*(D_Re*mu) * 16/(pi^2*D_Re^4*d) * m_flow*|m_flow|
      = 2*c0/(pi*D_Re^3) * mu/rho * m_flow
      = k0 * mu/rho * m_flow
   k0 = 2*c0/(pi*D_Re^3)

   In order that the derivative of dp=f(m_flow) is continuous
   at m_flow=0, the mean values of mu and d are used in the
   laminar region: mu/rho = (mu_a + mu_b)/(rho_a + rho_b)
   If data.zetaLaminarKnown = false then mu_a and mu_b are potentially zero
   (because dummy values) and therefore the division is only performed
   if zetaLaminarKnown = true.
*/
  assert(roughness > 1e-10,
         "roughness > 0 required for quadratic turbulent wall friction characteristic");
  // WARNING: The following equations are only correct for circular tubes!
  zeta   := (IN_con.length/diameter)/(2*log10(3.7 /(roughness/diameter)))^2;
  k0     := 128*IN_con.length/(pi*diameter^4);
  k_inv  := (pi*diameter*diameter)^2/(8*zeta);
  yd0    := (IN_var.rho_a + IN_var.rho_b)/(k0*(IN_var.mu_a + IN_var.mu_b));
  dp_turbulent := max(((IN_var.mu_a + IN_var.mu_b)*diameter*pi/8)^2*IN_con.Re_turbulent^2/(k_inv*(IN_var.rho_a+IN_var.rho_b)/2), dp_small);
  M_FLOW := Modelica.Fluid.Utilities.regRoot2(dp, dp_turbulent, IN_var.rho_a*k_inv, IN_var.rho_b*k_inv,
                                              use_yd0=true, yd0=yd0);
  annotation (smoothOrder=1, Documentation(info="<html>

</html>"));
end dp_MFLOW;
