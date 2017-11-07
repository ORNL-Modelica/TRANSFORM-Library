within TRANSFORM.Fluid.Valves;
model ValveIncompressible "Valve for (almost) incompressible fluids"
  extends BaseClasses.PartialValve;
  import TRANSFORM.Fluid.Types.CvTypes;
  import Modelica.Constants.pi;

  constant SI.ReynoldsNumber Re_turbulent = 4000
  "cf. straight pipe for fully open valve -- dp_turbulent increases for closing valve";
  parameter Boolean use_Re = false
  "= true, if turbulent region is defined by Re, otherwise by m_flow_small"
    annotation(Dialog(tab="Advanced"), Evaluate=true);
  //SI.MassFlowRate m_flow_turbulent=if not use_Re then m_flow_small else
  //  max(m_flow_small,
  //      (Modelica.Constants.pi/8)*sqrt(max(relativeFlowCoefficient,0.001)*Av*4/pi)*(Medium.dynamicViscosity(state_a) + Medium.dynamicViscosity(state_b))*Re_turbulent);
  //SI.AbsolutePressure dp_turbulent_=if not use_Re then dp_small else
  //  max(dp_small, m_flow_turbulent^2/(max(relativeFlowCoefficient,0.001)^2*Av^2*(Medium.density(state_a) + Medium.density(state_b))/2));
  // substitute m_flow_turbulent into dp_turbulent
  SI.AbsolutePressure dp_turbulent = if not use_Re then dp_small else
    max(dp_small, (Medium.dynamicViscosity(state_a) + Medium.dynamicViscosity(state_b))^2*pi/8*Re_turbulent^2
                  /(max(relativeFlowCoefficient,0.001)*Av*(Medium.density(state_a) + Medium.density(state_b))));

protected
  Real relativeFlowCoefficient;
initial equation
  if CvData == CvTypes.OpPoint then
  m_flow_nominal = valveCharacteristic(opening_nominal)*Av*sqrt(rho_nominal)
    *Modelica.Fluid.Utilities.regRoot(dp_nominal, dp_small)
    "Determination of Av by the operating point";
  end if;

equation
  // m_flow = valveCharacteristic(opening)*Av*sqrt(d)*sqrt(dp);

  relativeFlowCoefficient = valveCharacteristic(opening_actual);
  if checkValve then
  m_flow = homotopy(relativeFlowCoefficient*Av*sqrt(Medium.density(state_a))
    *Modelica.Fluid.Utilities.regRoot2(
        dp,
        dp_turbulent,
        1.0,
        0.0,
        use_yd0=true,
        yd0=0.0), relativeFlowCoefficient*m_flow_nominal*dp/dp_nominal);
    /* In Modelica 3.1 (Disadvantage: Unnecessary event at dp=0, and instead of smooth=2)
    m_flow = valveCharacteristic(opening)*Av*sqrt(Medium.density(state_a))*
                  (if dp>=0 then Utilities.regRoot(dp, dp_turbulent) else 0);
    */
  elseif not allowFlowReversal then
  m_flow = homotopy(relativeFlowCoefficient*Av*sqrt(Medium.density(state_a))
    *Modelica.Fluid.Utilities.regRoot(dp, dp_turbulent),
    relativeFlowCoefficient*m_flow_nominal*dp/dp_nominal);
  else
  m_flow = homotopy(relativeFlowCoefficient*Av*
    Modelica.Fluid.Utilities.regRoot2(
        dp,
        dp_turbulent,
        Medium.density(state_a),
        Medium.density(state_b)), relativeFlowCoefficient*m_flow_nominal*dp/
    dp_nominal);
    /* In Modelica 3.1 (Disadvantage: Unnecessary event at dp=0, and instead of smooth=2)
    m_flow = smooth(0, Utilities.regRoot(dp, dp_turbulent)*(if dp>=0 then sqrt(Medium.density(state_a)) else sqrt(Medium.density(state_b))));
    */
  end if;

annotation (
Documentation(info="<html>
<p>
Valve model according to the IEC 534/ISA S.75 standards for valve sizing, incompressible fluids.<
/p>

<p>
The parameters of this model are explained in detail in
<a href=\"modelica://Modelica.Fluid.Valves.BaseClasses.PartialValve\">PartialValve</a>
(the base model for valves).
</p>

<p>
This model assumes that the fluid has a low compressibility, which is always the case for liquids.
It can also be used with gases, provided that the pressure drop is lower than 0.2 times the absolute pressure at the inlet, so that the fluid density does not change much inside the valve.</p>

<p>
If <code>checkValve</code> is false, the valve supports reverse flow, with a symmetric flow characteristic curve. Otherwise, reverse flow is stopped (check valve behaviour).
</p>

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
end ValveIncompressible;
