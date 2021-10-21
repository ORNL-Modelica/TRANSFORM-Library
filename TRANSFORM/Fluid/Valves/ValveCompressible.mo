within TRANSFORM.Fluid.Valves;
model ValveCompressible
  "Valve for compressible fluids, accounts for choked flow conditions"
  extends BaseClasses.PartialValve;
  import TRANSFORM.Fluid.Types.CvTypes;
  import Modelica.Constants.pi;
  parameter Medium.AbsolutePressure p_nominal "Nominal inlet pressure"
  annotation(Dialog(group="Nominal operating point"));
  parameter Real Fxt_full=0.5 "Fk*xt critical ratio at full opening";
  replaceable function xtCharacteristic =
      TRANSFORM.Fluid.Valves.BaseClasses.ValveCharacteristics.one
    constrainedby TRANSFORM.Fluid.Valves.BaseClasses.ValveCharacteristics.baseFun
    "Critical ratio characteristic";
  Real Fxt;
  Real x "Pressure drop ratio";
  Real xs "Saturated pressure drop ratio";
  Real Y "Compressibility factor";
  Medium.AbsolutePressure p "Inlet pressure";
  constant SI.ReynoldsNumber Re_turbulent = 4000
    "cf. straight pipe for fully open valve -- dp_turbulent increases for closing valve";
  parameter Boolean use_Re = false
    "= true, if turbulent region is defined by Re, otherwise by m_flow_small"
    annotation(Dialog(tab="Advanced"), Evaluate=true);
  SI.AbsolutePressure dp_turbulent = if not use_Re then dp_small else
    max(dp_small, (Medium.dynamicViscosity(state_a) + Medium.dynamicViscosity(state_b))^2*pi/8*Re_turbulent^2
                  /(max(valveCharacteristic(opening_actual),0.001)*Av*Y*(Medium.density(state_a) + Medium.density(state_b))));
protected
  parameter Real Fxt_nominal(fixed=false) "Nominal Fxt";
  parameter Real x_nominal(fixed=false) "Nominal pressure drop ratio";
  parameter Real xs_nominal(fixed=false)
    "Nominal saturated pressure drop ratio";
  parameter Real Y_nominal(fixed=false) "Nominal compressibility factor";
initial equation
  if CvData == CvTypes.OpPoint then
    // Determination of Av by the nominal operating point conditions
    Fxt_nominal = Fxt_full*xtCharacteristic(opening_nominal);
    x_nominal = dp_nominal/p_nominal;
    xs_nominal = smooth(0, if x_nominal > Fxt_nominal then Fxt_nominal else x_nominal);
    Y_nominal = 1 - abs(xs_nominal)/(3*Fxt_nominal);
    m_flow_nominal = valveCharacteristic(opening_nominal)*Av*Y_nominal*sqrt(
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
  p = max(port_a.p, port_b.p);
  Fxt = Fxt_full*xtCharacteristic(opening_actual);
  x = dp/p;
  xs = max(-Fxt, min(x, Fxt));
  //xs = smooth(0, if x < -Fxt then -Fxt else if x > Fxt then Fxt else x);
  Y = 1 - abs(xs)/(3*Fxt);
  // m_flow = valveCharacteristic(opening)*Av*Y*sqrt(d)*sqrt(p*xs);
  if checkValve then
    m_flow = homotopy(valveCharacteristic(opening_actual)*Av*Y*sqrt(
      Medium.density(state_a))*smooth(0,(if xs >= 0 then
      Modelica.Fluid.Utilities.regRoot(p*xs, dp_turbulent) else 0)),
      valveCharacteristic(opening_actual)*m_flow_nominal*dp/dp_nominal);
    // m_flow = FlowChar(theta)*Av_internal*Y*sqrt(d)*smooth(0, if xs >= 0 then regSqrt(
    //   feed.p*xs) else 0);
  elseif not allowFlowReversal then
    m_flow = homotopy(valveCharacteristic(opening_actual)*Av*Y*sqrt(
      Medium.density(state_a))*Modelica.Fluid.Utilities.regRoot(p*xs,
      dp_turbulent), valveCharacteristic(opening_actual)*m_flow_nominal*dp/
      dp_nominal);
  else
    m_flow = homotopy(valveCharacteristic(opening_actual)*Av*Y*
      Modelica.Fluid.Utilities.regRoot2(
        p*xs,
        dp_turbulent,
        Medium.density(state_a),
        Medium.density(state_b)), valveCharacteristic(opening_actual)*
      m_flow_nominal*dp/dp_nominal);
/* alternative formulation using smooth(0, ...) -- should not be used as regRoot2 has continuous derivatives
   -- cf. ModelicaTest.Fluid.TestPipesAndValves.DynamicPipeInitialization --
    m_flow = homotopy(valveCharacteristic(opening_actual)*Av*Y*
                        smooth(0, Utilities.regRoot(p*xs, dp_turbulent)*
                        (if xs>=0 then sqrt(Medium.density(state_a)) else sqrt(Medium.density(state_b)))),
                      valveCharacteristic(opening_actual)*m_flow_nominal*dp/dp_nominal);
*/
  end if;
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
end ValveCompressible;
