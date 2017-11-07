within TRANSFORM.Fluid.Machines.BaseClasses;
partial model PartialPump "Base model for centrifugal pumps"
  import NonSI = Modelica.SIunits.Conversions.NonSIunits;
  import Modelica.Constants;

  Interfaces.FluidPort_Flow port_a(redeclare package Medium = Medium, m_flow(
        min=if checkValve then 0 else -Modelica.Constants.inf))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.FluidPort_Flow port_b(redeclare package Medium = Medium, m_flow(
        max=if checkValve then 0 else +Modelica.Constants.inf))
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  parameter Medium.AbsolutePressure p_a_start=1e5 "Pressure at port a"
    annotation (Dialog(tab="Initialization", group=
          "Start Value: Absolute Pressure"));
  parameter Medium.AbsolutePressure p_b_start=p_a_start + dp_nominal
    "Pressure at port b" annotation (Dialog(tab="Initialization", group=
          "Start Value: Absolute Pressure"));

  extends Volumes.BaseClasses.PartialVolume(
    V = 0,
    final p_start=if (exposeState_a and not exposeState_b) then p_a_start
         elseif (not exposeState_a and exposeState_b) then p_b_start else 0.5*(
        p_a_start + p_b_start),
    mb=port_a.m_flow + port_b.m_flow,
    Ub=port_a.m_flow*actualStream(port_a.h_outflow) + port_b.m_flow*
        actualStream(port_b.h_outflow) + Q_flow_internal + W,
    mXib=port_a.m_flow*actualStream(port_a.Xi_outflow) + port_b.m_flow*
        actualStream(port_b.Xi_outflow),
    mCb=port_a.m_flow*actualStream(port_a.C_outflow) + port_b.m_flow*
        actualStream(port_b.C_outflow) + mC_flow_internal);

  input SI.Length diameter=diameter_nominal "Impeller diameter"
    annotation (Dialog(group="Input Variables"));

  // Initialization
  parameter Medium.MassFlowRate m_flow_start=0 "Mass flow rate through pump"
    annotation (Dialog(tab="Initialization", group=
          "Start Value: Mass Flow Rate"));
  final parameter SI.Density d_start=Medium.density_pTX(
      p_b_start,
      T_start,
      X_start);
  final parameter SI.VolumeFlowRate V_flow_start=m_flow_start/d_start;

  // Advanced
  parameter Boolean exposeState_a=true
    "=true, p is calculated at port_a else m_flow"
    annotation (Dialog(group="Model Structure", tab="Advanced"));
  parameter Boolean exposeState_b=false
    "=true, p is calculated at port_b else m_flow"
    annotation (Dialog(group="Model Structure", tab="Advanced"));

  parameter Boolean checkValve=false "= true to prevent reverse flow"
    annotation (Dialog(tab="Advanced"), Evaluate=true);

  parameter SI.Acceleration g_n=Modelica.Constants.g_n
    "Gravitational accelaration" annotation (Dialog(tab="Advanced"));

  SI.PressureDifference dp=port_b.p - port_a.p "Pressure increase";
  // SI.MassFlowRate m_flow(start=m_flow_start) = port_a.m_flow "Mass flow rate";
  SI.MassFlowRate m_flow(start=m_flow_start) "Mass flow rate";
  NonSI.AngularVelocity_rpm N(start=N_nominal) "Shaft rotational speed";

  // Variables defined by closure models
  SI.Height head "Pump head";
  SI.Power W "Power Consumption";
  SI.Power W_ideal "Ideal power consumption";
  SI.Efficiency eta "Efficiency";
  SI.VolumeFlowRate V_flow(start=V_flow_start) = m_flow/medium.d
    "Volume flow rate";

  replaceable model FlowChar =
      TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Head.PerformanceCurve
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Head.PartialFlowChar
    "Head vs. Volumetric flow rate" annotation (Dialog(group=
          "Characteristics: Based on single pump nominal conditions"),
      choicesAllMatching=true);

  FlowChar flowChar(
    redeclare final package Medium = Medium,
    final state=medium.state,
    final V_flow_start=V_flow_start,
    final V_flow=V_flow,
    final V_flow_nominal=V_flow_nominal,
    final N=N,
    final diameter=diameter,
    final N_nominal=N_nominal,
    final diameter_nominal=diameter_nominal,
    final head_nominal=head_nominal,
    final checkValve=checkValve)
    annotation (Placement(transformation(extent={{-96,84},{-84,96}})));

  parameter Boolean use_powerCharacteristic=false
    "=true then use power characteristic else efficiency" annotation (Evaluate=
        true, Dialog(group=
          "Characteristics: Based on single pump nominal conditions"));

  replaceable model PowerChar =
      TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Power.Constant
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Power.PartialPowerChar
    "Power consumption vs. Volumetric flow rate" annotation (Dialog(group=
          "Characteristics: Based on single pump nominal conditions", enable=
          use_powerCharacteristic), choicesAllMatching=true);

  PowerChar powerChar(
    redeclare final package Medium = Medium,
    final state=medium.state,
    final V_flow_start=V_flow_start,
    final V_flow=V_flow,
    final V_flow_nominal=V_flow_nominal,
    final N=N,
    final diameter=diameter,
    final N_nominal=N_nominal,
    final diameter_nominal=diameter_nominal,
    final W_nominal=W_nominal,
    final m_flow=m_flow)
    annotation (Placement(transformation(extent={{-56,84},{-44,96}})));

  replaceable model EfficiencyChar =
      TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Efficiency.Constant
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Efficiency.PartialEfficiencyChar
    "Efficiency vs. Volumetric flow rate" annotation (Dialog(group=
          "Characteristics: Based on single pump nominal conditions", enable=
          not use_powerCharacteristic), choicesAllMatching=true);

  EfficiencyChar efficiencyChar(
    redeclare final package Medium = Medium,
    final state=medium.state,
    final V_flow_start=V_flow_start,
    final V_flow=V_flow,
    final V_flow_nominal=V_flow_nominal,
    final N=N,
    final diameter=diameter,
    final N_nominal=N_nominal,
    final diameter_nominal=diameter_nominal)
    annotation (Placement(transformation(extent={{-76,84},{-64,96}})));

  // Nominal conditions: Single pump basis
  parameter NonSI.AngularVelocity_rpm N_nominal=1500 "Pump speed"
    annotation (Dialog(group="Nominal Conditions: Single pump basis"));
  parameter SI.Length diameter_nominal=0.1 "Impeller diameter"
    annotation (Dialog(group="Nominal Conditions: Single pump basis"));
  parameter SI.PressureDifference dp_nominal=1e5 "Pressure increase"
    annotation (Dialog(group="Nominal Conditions: Single pump basis"));
  parameter SI.MassFlowRate m_flow_nominal=1 "Mass flow rate"
    annotation (Dialog(group="Nominal Conditions: Single pump basis"));
  parameter SI.Density d_nominal=Medium.density_phX(
      p_b_start,
      h_start,
      X_start) "Density"
    annotation (Dialog(group="Nominal Conditions: Single pump basis"));
  final parameter SI.VolumeFlowRate V_flow_nominal=m_flow_nominal/d_nominal;
  final parameter SI.Power W_nominal=dp_nominal*V_flow_nominal;
  final parameter SI.Height head_nominal=dp_nominal/(d_nominal*Modelica.Constants.g_n);

  parameter Boolean use_HeatPort = false "=true to toggle heat port" annotation(Dialog(tab="Advanced"),Evaluate=true);
  parameter Boolean use_TraceMassPort = false "=true to toggle trace mass port" annotation(Dialog(tab="Advanced"),Evaluate=true);
  parameter SI.MolarMass MMs[Medium.nC]=fill(1, Medium.nC)
    "Trace substances molar mass"
    annotation (Dialog(group="Closure Models", enable=use_TraceMassPort));

  HeatAndMassTransfer.Interfaces.HeatPort_State heatPort(T=medium.T, Q_flow=
        Q_flow_internal) if                                                                      use_HeatPort
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}}),
        iconTransformation(extent={{-10,-70},{10,-50}})));
  HeatAndMassTransfer.Interfaces.MolePort_State traceMassPort(
    nC=Medium.nC,
    C=C .* medium.d ./ MMs,
    n_flow=mC_flow_internal ./ MMs) if                                                                                            use_TraceMassPort
    annotation (Placement(transformation(extent={{30,-50},{50,-30}}),
        iconTransformation(extent={{30,-50},{50,-30}})));

protected
  SI.HeatFlowRate Q_flow_internal;
  SI.MassFlowRate mC_flow_internal[Medium.nC];

equation

  if not use_HeatPort then
    Q_flow_internal = 0;
  end if;
  if not use_TraceMassPort then
    mC_flow_internal = zeros(Medium.nC);
  end if;

  if use_powerCharacteristic then
    W = powerChar.W;
  else
    eta = efficiencyChar.eta;
  end if;

  W_ideal = m_flow/medium.d*dp;
  W = W_ideal/eta;
  head = flowChar.head;
  dp = medium.d*g_n*head;

  //heatPort.T = medium.T;

  if exposeState_a and exposeState_b then
    assert(false,
      "Single volume components cannot expose state at both ports a and b");
    //     port_a.p = medium.p;
    //     port_b.p = medium.p;
  elseif exposeState_a and not exposeState_b then
    port_a.p = medium.p;
    port_b.m_flow = -m_flow;
  elseif not exposeState_a and exposeState_b then
    port_a.m_flow = m_flow;
    port_b.p = medium.p;
  else
    port_a.m_flow = m_flow;
    port_b.m_flow = -m_flow;
  end if;

  // Boundary Conditions
  port_a.h_outflow = medium.h;
  port_b.h_outflow = medium.h;
  //port_b.p = medium.p;
  port_a.Xi_outflow = medium.Xi;
  port_b.Xi_outflow = medium.Xi;
  port_a.C_outflow = C;
  port_b.C_outflow = C;

  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-80,30},{-40,-30}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-2,60},{80,0}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{60,60},{-60,-60}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Sphere),
        Polygon(
          points={{-20,20},{-20,-22},{30,0},{-20,20}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{-92,30},{-108,-30}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_a),
        Ellipse(
          extent={{108,28},{92,-32}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=exposeState_b)}),   Documentation(info="<html>
<p>This is the base model for pumps.
<p>The model describes a centrifugal pump, or a group of <code>nParallel</code> identical pumps. The pump model is based on the theory of kinematic similarity: the pump characteristics are given for nominal operating conditions (rotational speed and fluid density), and then adapted to actual operating condition, according to the similarity equations.

<p><b>Pump characteristics</b></p>
<p> The nominal hydraulic characteristic (head vs. volume flow rate) is given by the the replaceable function <code>flowCharacteristic</code>.
<p> The pump energy balance can be specified in two alternative ways:
<ul>
<li><code>use_powerCharacteristic = false</code> (default option): the replaceable function <code>efficiencyCharacteristic</code> (efficiency vs. volume flow rate in nominal conditions) is used to determine the efficiency, and then the power consumption.
    The default is a constant efficiency of 0.8.</li>
<li><code>use_powerCharacteristic = true</code>: the replaceable function <code>powerCharacteristic</code> (power consumption vs. volume flow rate in nominal conditions) is used to determine the power consumption, and then the efficiency.
    Use <code>powerCharacteristic</code> to specify a non-zero power consumption for zero flow rate.
</ul>
<p>
Several functions are provided in the package <code>PumpCharacteristics</code> to specify the characteristics as a function of some operating points at nominal conditions.
<p>Depending on the value of the <code>checkValve</code> parameter, the model either supports reverse flow conditions, or includes a built-in check valve to avoid flow reversal.
</p>
<p>It is possible to take into account the mass and energy storage of the fluid inside the pump by specifying its volume <code>V</code>, and by selecting appropriate dynamic mass and energy balance assumptions (see below);
this is recommended to avoid singularities in the computation of the outlet enthalpy in case of zero flow rate.
If zero flow rate conditions are always avoided, this dynamic effect can be neglected by leaving the default value <code>V = 0</code>, thus avoiding fast state variables in the model.
</p>

<p><b>Dynamics options</b></p>
<p>
Steady-state mass and energy balances are assumed per default, neglecting the holdup of fluid in the pump; this configuration works well if the flow rate is always positive.
Dynamic mass and energy balance can be used by setting the corresponding dynamic parameters. This is recommended to avoid singularities at zero or reversing mass flow rate. If the initial conditions imply non-zero mass flow rate, it is possible to use the <code>SteadyStateInitial</code> condition, otherwise it is recommended to use <code>FixedInitial</code> in order to avoid undetermined initial conditions.
</p>

<p><b>Heat transfer</b></p>
<p>
The Boolean parameter <code>use_HeatTransfer</code> can be set to true if heat exchanged with the environment
should be taken into account or to model a housing. This might be desirable if a pump with realistic
<code>powerCharacteristic</code> for zero flow operates while a valve prevents fluid flow.
</p>

<p><b>Diagnostics of Cavitation</b></p>
<p>The replaceable Monitoring submodel can be configured to PumpMonitoringNPSH,
in order to compute the Net Positive Suction Head available and check for cavitation,
provided a two-phase medium model is used (see Advanced tab).
</p>
</html>", revisions="<html>
<ul>
<li><i>8 Jan 2013</i>
    by R&uuml;diger Franke:<br>
    moved NPSH diagnostics from PartialPump to replaceable sub-model PumpMonitoring.PumpMonitoringNPSH (see ticket #646)</li>
<li><i>Dec 2008</i>
    by R&uuml;diger Franke:<br>
    <ul>
    <li>Replaced simplified mass and energy balances with rigorous formulation (base class PartialLumpedVolume)</li>
    <li>Introduced optional HeatTransfer model defining Qb_flow</li>
    <li>Enabled events when the checkValve is operating to support the opening of a discrete valve before port_a</li>
    </ul></li>
<li><i>31 Oct 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Model added to the Fluid library</li>
</ul>
</html>"));
end PartialPump;
