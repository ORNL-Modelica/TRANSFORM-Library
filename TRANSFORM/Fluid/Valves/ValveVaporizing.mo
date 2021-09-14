within TRANSFORM.Fluid.Valves;
model ValveVaporizing
  "Valve for possibly vaporizing (almost) incompressible fluids, accounts for choked flow conditions"
  import TRANSFORM.Fluid.Types.CvTypes;
  import Modelica.Constants.pi;
  extends BaseClasses.PartialValve(
    redeclare replaceable package Medium =
        Modelica.Media.Water.WaterIF97_ph                                    constrainedby
      Modelica.Media.Interfaces.PartialTwoPhaseMedium);
  parameter Real Fl_nominal=0.9 "Liquid pressure recovery factor";
  replaceable function FlCharacteristic =
      TRANSFORM.Fluid.Valves.BaseClasses.ValveCharacteristics.one
    constrainedby TRANSFORM.Fluid.Valves.BaseClasses.ValveCharacteristics.baseFun
    "Pressure recovery characteristic";
  Real Ff "Ff coefficient (see IEC/ISA standard)";
  Real Fl "Pressure recovery coefficient Fl (see IEC/ISA standard)";
  SI.Pressure dpEff "Effective pressure drop";
  Medium.Temperature T_in "Inlet temperature";
  Medium.AbsolutePressure p_sat "Saturation pressure";
  Medium.AbsolutePressure p_in "Inlet pressure";
  Medium.AbsolutePressure p_out "Outlet pressure";
  constant SI.ReynoldsNumber Re_turbulent = 4000
    "cf. straight pipe for fully open valve -- dp_turbulent increases for closing valve";
  parameter Boolean use_Re = false
    "= true, if turbulent region is defined by Re, otherwise by m_flow_small"
    annotation(Dialog(tab="Advanced"), Evaluate=true);
  //SI.Diameter diameter = Utilities.regRoot(4/pi*valveCharacteristic(opening_actual)*Av, 0.04/pi*valveCharacteristic(opening_nominal)*Av);
  SI.AbsolutePressure dp_turbulent = if not use_Re then dp_small else
    max(dp_small, (Medium.dynamicViscosity(state_a) + Medium.dynamicViscosity(state_b))^2*pi/8*Re_turbulent^2
                  /(valveCharacteristic(opening_actual)*Av*(Medium.density(state_a) + Medium.density(state_b))));
initial equation
  assert(not CvData == CvTypes.OpPoint, "OpPoint option not supported for vaporizing valve");
equation
  p_in = port_a.p;
  p_out = port_b.p;
  T_in = Medium.temperature(state_a);
  p_sat = Medium.saturationPressure(T_in);
  Ff = 0.96 - 0.28*sqrt(p_sat/Medium.fluidConstants[1].criticalPressure);
  Fl = Fl_nominal*FlCharacteristic(opening_actual);
  dpEff = if p_out < (1 - Fl^2)*p_in + Ff*Fl^2*p_sat then
            Fl^2*(p_in - Ff*p_sat) else dp
    "Effective pressure drop, accounting for possible choked conditions";
  // m_flow = valveCharacteristic(opening)*Av*sqrt(d)*sqrt(dpEff);
  if checkValve then
    m_flow = homotopy(valveCharacteristic(opening_actual)*Av*sqrt(
      Medium.density(state_a))*Modelica.Fluid.Utilities.regRoot2(
        dpEff,
        dp_turbulent,
        1.0,
        0.0,
        use_yd0=true,
        yd0=0.0), valveCharacteristic(opening_actual)*m_flow_nominal*dp/
      dp_nominal);
   /* In Modelica 3.1 (Disadvantage: Unnecessary event at dpEff=0, and instead of smooth=2)
    m_flow = valveCharacteristic(opening)*Av*sqrt(Medium.density(state_a))*
                  (if dpEff>=0 then Utilities.regRoot(dpEff, dp_turbulent) else 0);
   */
  elseif not allowFlowReversal then
    m_flow = homotopy(valveCharacteristic(opening_actual)*Av*sqrt(
      Medium.density(state_a))*Modelica.Fluid.Utilities.regRoot(dpEff,
      dp_turbulent), valveCharacteristic(opening_actual)*m_flow_nominal*dp/
      dp_nominal);
  else
    m_flow = homotopy(valveCharacteristic(opening_actual)*Av*
      Modelica.Fluid.Utilities.regRoot2(
        dpEff,
        dp_turbulent,
        Medium.density(state_a),
        Medium.density(state_b)), valveCharacteristic(opening_actual)*
      m_flow_nominal*dp/dp_nominal);
    /* In Modelica 3.1 (Disadvantage: Unnecessary event at dp=0, and instead of smooth=2)
     m_flow = valveCharacteristic(opening)*Av*
      smooth(0, Utilities.regRoot(dpEff, dp_turbulent)*(if dpEff>=0 then sqrt(Medium.density(state_a)) else sqrt(Medium.density(state_b))));
   */
  end if;
  annotation (
    Documentation(info="<html>
<p>Valve model according to the IEC 534/ISA S.75 standards for valve sizing, incompressible fluid at the inlet, and possibly two-phase fluid at the outlet, including choked flow conditions.</p>

<p>
The parameters of this model are explained in detail in
<a href=\"modelica://Modelica.Fluid.Valves.BaseClasses.PartialValve\">PartialValve</a>
(the base model for valves).
</p>

<p>The model operating range includes choked flow operation, which takes place for low outlet pressures due to flashing in the vena contracta; otherwise, non-choking conditions are assumed.
<p>This model requires a two-phase medium model, to describe the liquid and (possible) two-phase conditions.
<p>The default liquid pressure recovery coefficient <code>Fl</code> is constant and given by the parameter <code>Fl_nominal</code>. The relative change (per unit) of the recovery coefficient can be specified as a given function of the valve opening by replacing the <code>FlCharacteristic</code> function.
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
end ValveVaporizing;
