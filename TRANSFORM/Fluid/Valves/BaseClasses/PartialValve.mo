within TRANSFORM.Fluid.Valves.BaseClasses;
partial model PartialValve "Base model for valves"

  import TRANSFORM.Fluid.Types.CvTypes;
  extends TRANSFORM.Fluid.Valves.BaseClasses.PartialTwoPortTransport(
    dp_start = dp_nominal,
    m_flow_small = 1e-4*m_flow_nominal,
    m_flow_start = m_flow_nominal);

  parameter Modelica.Fluid.Types.CvTypes CvData=Modelica.Fluid.Types.CvTypes.OpPoint
    "Selection of flow coefficient"
   annotation(Dialog(group = "Flow Coefficient"));
  parameter SI.Area Av(
    fixed=if CvData == Modelica.Fluid.Types.CvTypes.Av then true else false,
    start=m_flow_nominal/(sqrt(rho_nominal*dp_nominal))*valveCharacteristic(
        opening_nominal)) "Av (metric) flow coefficient"
   annotation(Dialog(group = "Flow Coefficient",
                     enable = (CvData==Modelica.Fluid.Types.CvTypes.Av)));
  parameter Real Kv = 0 "Kv (metric) flow coefficient [m3/h]"
  annotation(Dialog(group = "Flow Coefficient",
                    enable = (CvData==Modelica.Fluid.Types.CvTypes.Kv)));
  parameter Real Cv = 0 "Cv (US) flow coefficient [USG/min]"
  annotation(Dialog(group = "Flow Coefficient",
                    enable = (CvData==Modelica.Fluid.Types.CvTypes.Cv)));
  parameter SI.Pressure dp_nominal "Nominal pressure drop"
  annotation(Dialog(group="Nominal operating point"));
  parameter Medium.MassFlowRate m_flow_nominal "Nominal mass flowrate"
  annotation(Dialog(group="Nominal operating point"));
  parameter Medium.Density rho_nominal=Medium.density_pTX(Medium.p_default, Medium.T_default, Medium.X_default)
    "Nominal inlet density"
  annotation(Dialog(group="Nominal operating point",
                    enable = (CvData==Modelica.Fluid.Types.CvTypes.OpPoint)));
  parameter Real opening_nominal(min=0,max=1)=1 "Nominal opening"
  annotation(Dialog(group="Nominal operating point",
                    enable = (CvData==Modelica.Fluid.Types.CvTypes.OpPoint)));

  parameter Boolean filteredOpening=false
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(group="Filtered opening"),choices(checkBox=true));
  parameter Modelica.SIunits.Time riseTime=1
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation(Dialog(group="Filtered opening",enable=filteredOpening));
  parameter Real leakageOpening(min=0,max=1)=1e-3
    "The opening signal is limited by leakageOpening (to improve the numerics)"
    annotation(Dialog(group="Filtered opening",enable=filteredOpening));
  parameter Boolean checkValve=false "Reverse flow stopped"
    annotation(Dialog(tab="Assumptions"));

  replaceable function valveCharacteristic =
      TRANSFORM.Fluid.Valves.BaseClasses.ValveCharacteristics.linear
    constrainedby
    TRANSFORM.Fluid.Valves.BaseClasses.ValveCharacteristics.baseFun
    "Inherent flow characteristic"
    annotation(choicesAllMatching=true);

  parameter SI.Pressure dp_small=dp_nominal/m_flow_nominal*m_flow_small
    "Regularisation of zero flow"
   annotation(Dialog(tab="Advanced"));

public
  constant SI.Area Kv2Av = 27.7e-6 "Conversion factor";
  constant SI.Area Cv2Av = 24.0e-6 "Conversion factor";

  Modelica.Blocks.Interfaces.RealInput opening(min=0, max=1)
    "Valve position in the range 0..1"
                                   annotation (Placement(transformation(
        origin={0,90},
        extent={{-20,-20},{20,20}},
        rotation=270), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,80})));

  Modelica.Blocks.Interfaces.RealOutput opening_filtered if filteredOpening
    "Filtered valve position in the range 0..1"
    annotation (Placement(transformation(extent={{60,40},{80,60}}),
        iconTransformation(extent={{60,50},{80,70}})));

  Modelica.Blocks.Continuous.Filter filter(order=2, f_cut=5/(2*Modelica.Constants.pi
        *riseTime)) if filteredOpening
    annotation (Placement(transformation(extent={{34,44},{48,58}})));

protected
  Modelica.Blocks.Interfaces.RealOutput opening_actual
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

block MinLimiter "Limit the signal above a threshold"
 parameter Real uMin=0 "Lower limit of input signal";
  extends Modelica.Blocks.Interfaces.SISO;

equation
  y = smooth(0, noEvent( if u < uMin then uMin else u));
  annotation (
    Documentation(info="<html>
<p>
The block passes its input signal as output signal
as long as the input is above uMin. If this is not the case,
y=uMin is passed as output.
</p>
</html>"), Icon(coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}}), graphics={
    Line(points={{0,-90},{0,68}}, color={192,192,192}),
    Polygon(
      points={{0,90},{-8,68},{8,68},{0,90}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-90,0},{68,0}}, color={192,192,192}),
    Polygon(
      points={{90,0},{68,-8},{68,8},{90,0}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-80,-70},{-50,-70},{50,70},{64,90}}),
    Text(
      extent={{-150,-150},{150,-110}},
      lineColor={0,0,0},
            textString="uMin=%uMin"),
    Text(
      extent={{-150,150},{150,110}},
      textString="%name",
      lineColor={0,0,255})}),
    Diagram(coordinateSystem(
    preserveAspectRatio=true,
    extent={{-100,-100},{100,100}}), graphics={
    Line(points={{0,-60},{0,50}}, color={192,192,192}),
    Polygon(
      points={{0,60},{-5,50},{5,50},{0,60}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-60,0},{50,0}}, color={192,192,192}),
    Polygon(
      points={{60,0},{50,-5},{50,5},{60,0}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-50,-40},{-30,-40},{30,40},{50,40}}),
    Text(
      extent={{46,-6},{68,-18}},
      lineColor={128,128,128},
      textString="u"),
    Text(
      extent={{-30,70},{-5,50}},
      lineColor={128,128,128},
      textString="y"),
    Text(
      extent={{-58,-54},{-28,-42}},
      lineColor={128,128,128},
      textString="uMin"),
    Text(
      extent={{26,40},{66,56}},
      lineColor={128,128,128},
      textString="uMax")}));
end MinLimiter;

  MinLimiter minLimiter(uMin=leakageOpening)
    annotation (Placement(transformation(extent={{10,44},{24,58}})));
initial equation
  if CvData == CvTypes.Kv then
    Av = Kv*Kv2Av "Unit conversion";
  elseif CvData == CvTypes.Cv then
    Av = Cv*Cv2Av "Unit conversion";
  end if;

equation
  // Isenthalpic state transformation (no storage and no loss of energy)
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);

  connect(filter.y, opening_filtered) annotation (Line(
      points={{48.7,51},{60,51},{60,50},{70,50}},
      color={0,0,127}));

  if filteredOpening then
     connect(filter.y, opening_actual);
  else
     connect(opening, opening_actual);
  end if;

  connect(minLimiter.y, filter.u) annotation (Line(
      points={{24.7,51},{32.6,51}},
      color={0,0,127}));
  connect(minLimiter.u, opening) annotation (Line(
      points={{8.6,51},{0,51},{0,90}},
      color={0,0,127}));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{0,52},{0,0}}),
        Rectangle(
          extent={{-20,60},{20,52}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,50},{100,-50},{100,50},{0,0},{-100,-50},{-100,50}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points=DynamicSelect({{-100,0},{100,-0},{100,0},{0,0},{-100,-0},{
              -100,0}}, {{-100,50*opening_actual},{-100,50*opening_actual},{100,-50*
              opening},{100,50*opening_actual},{0,0},{-100,-50*opening_actual},{-100,50*
              opening}}),
          fillColor={0,255,0},
          lineColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(points={{-100,50},{100,-50},{100,50},{0,0},{-100,-50},{-100,
              50}}, lineColor={0,0,0}),
        Ellipse(visible=filteredOpening,
          extent={{-40,94},{40,14}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(visible=filteredOpening,
          points={{-20,25},{-20,63},{0,41},{20,63},{20,25}},
          thickness=0.5),
        Line(visible=filteredOpening,
          points={{40,60},{60,60}},
          color={0,0,127})}),
    Documentation(info="<html>
<p>This is the base model for the <code>ValveIncompressible</code>, <code>ValveVaporizing</code>, and <code>ValveCompressible</code> valve models. The model is based on the IEC 534 / ISA S.75 standards for valve sizing.</p>
<p>The model optionally supports reverse flow conditions (assuming symmetrical behaviour) or check valve operation, and has been suitably regularized, compared to the equations in the standard, in order to avoid numerical singularities around zero pressure drop operating conditions.</p>
<p>The model assumes adiabatic operation (no heat losses to the ambient); changes in kinetic energy
from inlet to outlet are neglected in the energy balance.</p>
<p><b>Modelling options</b></p>
<p>The following options are available to specify the valve flow coefficient in fully open conditions:
<ul><li><code>CvData = Modelica.Fluid.Types.CvTypes.Av</code>: the flow coefficient is given by the metric <code>Av</code> coefficient (m^2).
<li><code>CvData = Modelica.Fluid.Types.CvTypes.Kv</code>: the flow coefficient is given by the metric <code>Kv</code> coefficient (m^3/h).
<li><code>CvData = Modelica.Fluid.Types.CvTypes.Cv</code>: the flow coefficient is given by the US <code>Cv</code> coefficient (USG/min).
<li><code>CvData = Modelica.Fluid.Types.CvTypes.OpPoint</code>: the flow is computed from the nominal operating point specified by <code>p_nominal</code>, <code>dp_nominal</code>, <code>m_flow_nominal</code>, <code>rho_nominal</code>, <code>opening_nominal</code>.
</ul>
<p>The nominal pressure drop <code>dp_nominal</code> must always be specified; to avoid numerical singularities, the flow characteristic is modified for pressure drops less than <code>b*dp_nominal</code> (the default value is 1% of the nominal pressure drop). Increase this parameter if numerical problems occur in valves with very low pressure drops.
<p>If <code>checkValve</code> is true, then the flow is stopped when the outlet pressure is higher than the inlet pressure; otherwise, reverse flow takes place. Use this option only when needed, as it increases the numerical complexity of the problem.
<p>The valve opening characteristic <code>valveCharacteristic</code>, linear by default, can be replaced by any user-defined function. Quadratic and equal percentage with customizable rangeability are already provided by the library. The characteristics for constant port_a.p and port_b.p pressures with continuously changing opening are shown in the next two figures:
</p>

<blockquote>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/ValveCharacteristics1a.png\"
     alt=\"ValveCharacteristics1a.png\"><br>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/ValveCharacteristics1b.png\"
     alt=\"Components/ValveCharacteristics1b.png\">
</blockquote>

<p>
The treatment of parameters <b>Kv</b> and <b>Cv</b> is
explained in detail in the
<a href=\"modelica://Modelica.Fluid.UsersGuide.ComponentDefinition.ValveCharacteristics\">User's Guide</a>.
</p>

<p>
With the optional parameter \"filteredOpening\", the opening can be filtered with a
<b>second order, criticalDamping</b> filter so that the
opening demand is delayed by parameter \"riseTime\". The filtered opening is then available
via the output signal \"opening_filtered\" and is used to control the valve equations.
This approach approximates the driving device of a valve. The \"riseTime\" parameter
is used to compute the cut-off frequency of the filter by the equation: f_cut = 5/(2*pi*riseTime).
It defines the time that is needed until opening_filtered reaches 99.6 % of
a step input of opening. The icon of a valve changes in the following way
(left image: filteredOpening=false, right image: filteredOpening=true):
</p>

<blockquote>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/FilteredValveIcon.png\"
     alt=\"FilteredValveIcon.png\">
</blockquote>

<p>
If \"filteredOpening = <b>true</b>\", the input signal \"opening\" is limited
by parameter <b>leakageOpening</b>, i.e., if \"opening\" becomes smaller as
\"leakageOpening\", then \"leakageOpening\" is used instead of \"opening\" as input
for the filter. The reason is that \"opening=0\" might structurally change the equations of the
fluid network leading to a singularity. If a small leakage flow is introduced
(which is often anyway present in reality), the singularity might be avoided.
</p>

<p>
In the next figure, \"opening\" and \"filtered_opening\" are shown in the case that
filteredOpening = <b>true</b>, riseTime = 1 s, and leakageOpening = 0.02.
</p>

<blockquote>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/ValveFilteredOpening.png\"
     alt=\"ValveFilteredOpening.png\">
</blockquote>

</html>",
      revisions="<html>
<ul>
<li><i>Sept. 5, 2010</i>
    by <a href=\"mailto:martin.otter@dlr.de\">Martin Otter</a>:<br>
    Optional filtering of opening introduced, based on a proposal
    from Mike Barth (Universitaet der Bundeswehr Hamburg) +
    Documentation improved.</li>
<li><i>2 Nov 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Adapted from the ThermoPower library.</li>
</ul>
</html>"));
end PartialValve;
