within TRANSFORM.Fluid.Volumes;
model ExpansionTank "Expansion tank with cover gas"
  extends TRANSFORM.Fluid.Interfaces.Records.Medium_fluid;
  //   package Medium = Modelica.Media.Water.StandardWater (extraPropertiesNames={"CO2"},
  //         C_nominal={1.519E-1});
  import Modelica.Fluid.Types.Dynamics;
  parameter SI.Area A "Cross-sectional area";
  parameter SI.Volume V0=0 "Volume at zero level";
  input SI.Pressure p_surface=p_start "Liquid surface/gas pressure" annotation(Dialog(group="Inputs"));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction"
    annotation (Dialog(tab="Advanced"));
  parameter SI.Pressure p_start = 1e5 annotation(Dialog(tab="Initialization"));
  parameter SI.Length level_start "Start level"
    annotation (Dialog(tab="Initialization"));
  parameter SI.SpecificEnthalpy h_start=1e5
    annotation (Dialog(tab="Initialization"));
  parameter Dynamics massDynamics=Dynamics.DynamicFreeInitial
    "Formulation of mass balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics traceDynamics=massDynamics
    "Formulation of trace substance balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter SI.MassFraction X_start[Medium.nX]=Medium.X_default "Mass fraction"
    annotation (Dialog(
      tab="Initialization",
      group="Start Value: Species Mass Fraction",
      enable=Medium.nXi > 0));
  parameter SIadd.ExtraProperty C_start[Medium.nC]=fill(0, Medium.nC)
    "Mass-Specific value" annotation (Dialog(
      tab="Initialization",
      group="Start Value: Trace Substances",
      enable=Medium.nC > 0));
  constant Real g_n=Modelica.Constants.g_n;
  Medium.ThermodynamicState state_liquid "Thermodynamic state of the liquid";
  SI.Length level(start=level_start, stateSelect=StateSelect.prefer)
    "Liquid level";
  SI.Volume V "Liquid volume";
  SI.Mass m "Liquid mass";
  SI.InternalEnergy U "Liquid internal energy";
  Medium.SpecificEnthalpy h(start=h_start, stateSelect=StateSelect.prefer)
    "Liquid specific enthalpy";
  Medium.AbsolutePressure p(start=p_start) "Bottom pressure";
  SI.Mass mXi[Medium.nXi] "Species mass";
  SIadd.ExtraPropertyExtrinsic mC[Medium.nC] "Trace substance extrinsic value";
  SI.MassFraction Xi[Medium.nXi](start=Medium.reference_X[1:Medium.nXi])
    "Structurally independent mass fractions";
  SIadd.ExtraProperty C[Medium.nC](stateSelect=StateSelect.prefer, start=C_start)
    "Trace substance mass-specific value";
  // Species Balance
  SI.MassFlowRate mXib[Medium.nXi]
    "Species mass flow rates source/sinks within volumes";
  // Trace Balance
  SIadd.ExtraPropertyFlowRate mCb[Medium.nC]
    "Trace flow rate source/sinks within volumes (e.g., chemical reactions, external convection)";
  TRANSFORM.Fluid.Interfaces.FluidPort_State port_a(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=h_start),
    p(start=Medium.density(Medium.setState_phX(p_start, h_start))*g_n*
          level_start + p_start))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-70},{-50,-30}}, rotation=
           0), iconTransformation(extent={{-80,-70},{-60,-50}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_State port_b(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=h_start),
    p(start=Medium.density(Medium.setState_phX(p_start, h_start))*g_n*
          level_start + p_start))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{50,-70},{90,-30}}, rotation=0),
        iconTransformation(extent={{60,-70},{80,-50}})));
  parameter Boolean use_HeatPort = false "=true to toggle heat port" annotation(Dialog(tab="Advanced",group="Heat Transfer"),Evaluate=true);
  input SI.HeatFlowRate Q_gen=0 "Internal heat generation" annotation(Dialog(tab="Advanced",group="Heat Transfer"));
  parameter Boolean use_TraceMassPort = false "=true to toggle trace mass port" annotation(Dialog(tab="Advanced",group="Trace Mass Transfer"),Evaluate=true);
  parameter Real MMs[Medium.nC]=fill(1, Medium.nC)
    "Conversion from fluid mass-specific value to moles (e.g., molar mass [kg/mol] or Avogadro's number [atoms/mol])"
    annotation (Dialog(tab="Advanced",group="Trace Mass Transfer", enable=use_TraceMassPort));
  input SIadd.ExtraPropertyFlowRate mC_gen[Medium.nC]=fill(0,Medium.nC) "Internal trace mass generation"
    annotation (Dialog(tab="Advanced",group="Trace Mass Transfer"));
  HeatAndMassTransfer.Interfaces.HeatPort_State heatPort(T=Medium.temperature(state_liquid), Q_flow=
        Q_flow_internal)                                                                      if use_HeatPort
    annotation (Placement(transformation(extent={{-10,-94},{10,-74}}),
        iconTransformation(extent={{-10,-94},{10,-74}})));
  HeatAndMassTransfer.Interfaces.MolePort_State traceMassPort(
    nC=Medium.nC,
    C=C .* Medium.density(state_liquid) ./ MMs,
    n_flow=mC_flow_internal ./ MMs)                                                                                            if use_TraceMassPort
    annotation (Placement(transformation(extent={{30,-86},{50,-66}}),
        iconTransformation(extent={{30,-86},{50,-66}})));
  // Visualization
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
protected
  SI.HeatFlowRate Q_flow_internal;
  SIadd.ExtraPropertyFlowRate mC_flow_internal[Medium.nC];
initial equation
  if massDynamics == Dynamics.FixedInitial then
    h = h_start;
    level = level_start;
    Xi = X_start[1:Medium.nXi];
  elseif massDynamics == Dynamics.SteadyStateInitial then
    der(h) = 0;
    der(level) = 0;
    der(Xi) = zeros(Medium.nXi);
  end if;
  // Trace Balance
  if traceDynamics == Dynamics.FixedInitial then
    C = C_start;
  elseif traceDynamics == Dynamics.SteadyStateInitial then
    der(mC) = zeros(Medium.nC);
  end if;
equation
  if not use_HeatPort then
    Q_flow_internal = 0;
  end if;
  if not use_TraceMassPort then
    mC_flow_internal = zeros(Medium.nC);
  end if;
  // Set liquid properties
  state_liquid = Medium.setState_phX(p_surface, h);
  V = V0 + A*level;
  m = V*Medium.density(state_liquid);
  U = m*Medium.specificInternalEnergy(state_liquid);
  p - p_surface = Medium.density(state_liquid)*g_n*level;
  mC = m*C;
  if massDynamics == Dynamics.SteadyState then
    der(m) = 0;
    der(U) = 0;
  else
    der(m) = port_a.m_flow + port_b.m_flow;
    der(U) = port_a.m_flow*actualStream(port_a.h_outflow) + port_b.m_flow*
      actualStream(port_b.h_outflow)+Q_flow_internal+Q_gen;
  end if;
  // Species Balance
  if massDynamics == Dynamics.SteadyState then
    zeros(Medium.nXi) = mXib;
  else
    der(mXi) = mXib;
  end if;
  // Trace Balance
  if traceDynamics == Dynamics.SteadyState then
    zeros(Medium.nC) = mCb;
  else
    der(mC) = mCb;
  end if;
  for i in 1:Medium.nXi loop
    mXib[i] = port_a.m_flow*actualStream(port_a.Xi_outflow[i]) + port_b.m_flow*
      actualStream(port_b.Xi_outflow[i]);
  end for;
  for i in 1:Medium.nC loop
    mCb[i] = port_a.m_flow*actualStream(port_a.C_outflow[i]) + port_b.m_flow*
      actualStream(port_b.C_outflow[i]) + mC_gen[i] + mC_flow_internal[i];
  end for;
  port_a.h_outflow = h;
  port_b.h_outflow = h;
  port_a.p = p;
  port_b.p = p;
  for i in 1:Medium.nXi loop
    port_a.Xi_outflow[i] = Xi[i];
    port_b.Xi_outflow[i] = Xi[i];
  end for;
  for i in 1:Medium.nC loop
    port_a.C_outflow[i] = C[i];
    port_b.C_outflow[i] = C[i];
  end for;
  annotation (defaultComponentName="tank",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(
          extent={{-85,85},{85,-85}},
          fillColor={0,128,255},
          fillPattern=FillPattern.Sphere,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-85,-85},{85,85}},
          pattern=LinePattern.None,
          lineColor={135,135,135},
          fillColor={255,255,255},
          fillPattern=FillPattern.Sphere,
          startAngle=0,
          endAngle=180),
        Text(
          extent={{-151,134},{149,94}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),
                                     Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}})));
end ExpansionTank;
