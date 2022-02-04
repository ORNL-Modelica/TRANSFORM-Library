within TRANSFORM.Fluid.Valves.Nozzles;
model SimpleNozzle "Simple nozzle"
  extends BaseClasses.PartialNozzle(rho_nominal=Medium.density_pT(p_nominal, T_nominal));
  import TRANSFORM.Fluid.Types.CvTypes;
  import Modelica.Constants.pi;
  parameter Medium.AbsolutePressure p_nominal "Nominal inlet pressure"
  annotation(Dialog(group="Nominal operating point"));
  parameter Medium.Temperature T_nominal "Nominal inlet temperature"
  annotation(Dialog(group="Nominal operating point"));
  //input Real Fxt_full=0.5 "Fk*xt critical ratio at full opening" annotation(Dialog(group="Inputs"));
  replaceable function xtCharacteristic =
      TRANSFORM.Fluid.Valves.BaseClasses.ValveCharacteristics.one
    constrainedby
    TRANSFORM.Fluid.Valves.BaseClasses.ValveCharacteristics.baseFun
    "Critical ratio characteristic";
  Real Fxt;
  Real x "Pressure drop ratio";
  Real xs "Saturated pressure drop ratio";
  Real Y "Compressibility factor";
  Medium.AbsolutePressure p "Inlet pressure";
  Modelica.Units.SI.IsentropicExponent gamma_a = Medium.isentropicExponent(state_a) "Specific heat ratio at port a";
  Modelica.Units.SI.IsentropicExponent gamma_b = Medium.isentropicExponent(state_b) "Specific heat ratio at port b";
  Modelica.Units.SI.Density rho_a = Medium.density(state_a);
  Modelica.Units.SI.Density rho_b = Medium.density(state_b);
  Real x_a;
  Real x_b;
  Real xChoice;
  input Modelica.Units.SI.Acceleration g_n = Modelica.Constants.g_n annotation(Dialog(tab="Assumptions"));
  Modelica.Units.SI.Time Isp "Specific impulse";
  Modelica.Units.SI.Velocity v_e "Nozzle Exit Velocity";
  input Modelica.Units.SI.Area A_t=1 "Throat Area" annotation(Dialog(tab="Assumptions"));
  input Real A_ratio = 300 "Nozzle area ratio" annotation(Dialog(tab="Assumptions"));
  Modelica.Units.SI.Area A_e=A_t*A_ratio "Exit Area";
  Modelica.Units.SI.Force thrust "Nozzle Thrust";
  //Modelica.Units.SI.Pressure p_kinetic "Kinetic pressure";
  Modelica.Units.SI.Pressure p_e "Total exit pressure";
  Real M_e(start=10.0) "Mach number exit";
  //Modelica.Units.SI.Velocity c_star "Characteristic velocity";
  Modelica.Units.SI.Velocity C "Effective exhaust velocity";
  //Real C_f "Thrust coefficient";
  //Modelica.Units.SI.Pressure p_e "Expanded pressure";
  input Real efficiency=1.0 annotation(Dialog(tab="Assumptions"));
  constant Modelica.Units.SI.ReynoldsNumber Re_turbulent=4000
    "cf. straight pipe for fully open valve -- dp_turbulent increases for closing valve";
  parameter Boolean use_Re = false
    "= true, if turbulent region is defined by Re, otherwise by m_flow_small"
    annotation(Dialog(tab="Advanced"), Evaluate=true);
  Modelica.Units.SI.AbsolutePressure dp_turbulent=if not use_Re then dp_small
       else max(dp_small, (Medium.dynamicViscosity(state_a) +
      Medium.dynamicViscosity(state_b))^2*pi/8*Re_turbulent^2/(max(
      1, 0.001)*Av*Y*(Medium.density(state_a) +
      Medium.density(state_b))));
protected
  parameter Real Fxt_nominal(fixed=false) "Nominal Fxt";
  parameter Real x_nominal(fixed=false) "Nominal pressure drop ratio";
  parameter Real xs_nominal(fixed=false)
    "Nominal saturated pressure drop ratio";
  parameter Real Y_nominal(fixed=false) "Nominal compressibility factor";
initial equation
  if CvData == CvTypes.OpPoint then
    // Determination of Av by the nominal operating point conditions
    Fxt_nominal = x_a*xtCharacteristic(1.0);
    x_nominal = dp_nominal/p_nominal;
    xs_nominal = smooth(0, if x_nominal > Fxt_nominal then Fxt_nominal else x_nominal);
    Y_nominal = 1 - abs(xs_nominal)/(3*Fxt_nominal);
    m_flow_nominal = valveCharacteristic(1.0)*Av*Y_nominal*sqrt(
      rho_nominal)*Modelica.Fluid.Utilities.regRoot(p_nominal*xs_nominal,
      dp_small);
  else
    // Dummy values
    Fxt_nominal = 0;
    x_nominal = 0;
    xs_nominal = 0;
    Y_nominal = 0;
  end if;
equation
  x_a = (2/(gamma_a+1))^(gamma_a/(gamma_a-1));
  x_b = (2/(gamma_b+1))^(gamma_b/(gamma_b-1));

  if port_b.p > port_a.p then
    p=port_b.p;
    xChoice=x_b;
  else
    p=port_a.p;
    xChoice=x_a;
  end if;
  Fxt = x_a*xtCharacteristic(1.0);
  x*p = dp;
  xs = max(-Fxt, min(x, Fxt));
  //xs = smooth(0, if x < -Fxt then -Fxt else if x > Fxt then Fxt else x);
  Y = 1 - abs(xs)/(3*Fxt);
  // m_flow = valveCharacteristic(opening)*Av*Y*sqrt(d)*sqrt(p*xs);
  if checkValve then
    m_flow = homotopy(valveCharacteristic(1.0)*Av*Y*sqrt(
      Medium.density(state_a))*smooth(0,(if xs >= 0 then
      Modelica.Fluid.Utilities.regRoot(p*xs, dp_turbulent) else 0)),
      valveCharacteristic(1.0)*m_flow_nominal*dp/dp_nominal);
    // m_flow = FlowChar(theta)*Av_internal*Y*sqrt(d)*smooth(0, if xs >= 0 then regSqrt(
    //   feed.p*xs) else 0);
  elseif not allowFlowReversal then
    m_flow = homotopy(valveCharacteristic(1.0)*Av*Y*sqrt(
      Medium.density(state_a))*Modelica.Fluid.Utilities.regRoot(p*xs,
      dp_turbulent), valveCharacteristic(1.0)*m_flow_nominal*dp/
      dp_nominal);
  else
    m_flow = homotopy(valveCharacteristic(1.0)*Av*Y*
      Modelica.Fluid.Utilities.regRoot2(
        p*xs,
        dp_turbulent,
        Medium.density(state_a),
        Medium.density(state_b)), valveCharacteristic(1.0)*
      m_flow_nominal*dp/dp_nominal);
/* alternative formulation using smooth(0, ...) -- should not be used as regRoot2 has continuous derivatives
   -- cf. ModelicaTest.Fluid.TestPipesAndValves.DynamicPipeInitialization --
    m_flow = homotopy(valveCharacteristic(opening_actual)*Av*Y*
                        smooth(0, Utilities.regRoot(p*xs, dp_turbulent)*
                        (if xs>=0 then sqrt(Medium.density(state_a)) else sqrt(Medium.density(state_b)))),
                      valveCharacteristic(opening_actual)*m_flow_nominal*dp/dp_nominal);
*/
  end if;
  //c_star = sqrt(Modelica.Constants.R/Medium.molarMass(state_a)*port_a_T/gamma_a)*((gamma_a+1)/2)^((gamma_a+1)/(2*(gamma_a-1)));
  //Calculate c_star
  //c_star = port_a.p*A_t/m_flow;//Correct (above is also correct)
  //Use area ratio to calculate M_e
  A_ratio*M_e = ((gamma_a+1)/2)^((gamma_a+1)/(-2*(gamma_a-1)))*((1+(gamma_a-1)/2*M_e^2)^((gamma_a+1)/(2*(gamma_a-1))));//Correct

  //Use M_e and c_star to calculate v_e
  //v_e = c_star*gamma_a*M_e/sqrt(1+(gamma_a-1)/2*M_e^2)*((gamma_a+1)/2)^((gamma_a+1)/(-2*(gamma_a-1)));
  //v_e = M_e*sqrt(gamma_a
  v_e = M_e*sqrt(gamma_a*Modelica.Constants.R/Medium.molarMass(state_a)*port_a_T*(1/(1+(gamma_a-1)/2*M_e^2)));
  //Need exit dynamic pressure
  p_e *(1+(gamma_a-1)/2*M_e^2)^(gamma_a/(gamma_a-1)) = port_a.p;
  //v_e to calculate thrust
  C = p_e * A_e/m_flow + v_e;
  //C_f*c_star*efficiency = C;
  thrust = C * m_flow *efficiency;
  //Now for Isp
  Isp * g_n *m_flow = thrust;

  annotation (
  Documentation(info="<html>
<p>Valve model according to the IEC 534/ISA S.75 standards for valve sizing, compressible fluid, no phase change, also covering choked-flow conditions.</p>

<p>
The parameters of this model are explained in detail in
<a href=\"modelica://Modelica.Fluid.Valves.BaseClasses.PartialValve\">PartialValve</a>
(the base model for valves).
</p>

<p>This model can be used with gases and vapours, with arbitrary pressure ratio between inlet and outlet.</p>

<p>The product Fk*xt is given by the parameter <code>Fxt_full</code>, and is assumed constant by default. The relative change (per unit) of the xt coefficient with the valve opening can be specified by replacing the <code>xtCharacteristic</code> function.
<p>If <code>checkValve</code> is false, the valve supports reverse flow, with a symmetric flow characteristic curve. Otherwise, reverse flow is stopped (check valve behaviour).</p>

<p>
The treatment of parameters <b>Kv</b> and <b>Cv</b> is
explained in detail in the
<a href=\"modelica://Modelica.Fluid.UsersGuide.ComponentDefinition.ValveCharacteristics\">User's Guide</a>.
</p>

</html>",
    revisions="<html>
<ul>
<li><i>2 Nov 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Adapted from the ThermoPower library.</li>
</ul>
</html>"));
end SimpleNozzle;
