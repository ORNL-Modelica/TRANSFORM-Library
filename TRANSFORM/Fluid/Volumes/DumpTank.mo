within TRANSFORM.Fluid.Volumes;
model DumpTank "Expansion tank with cover gas"
  import Modelica.Fluid.Types.Dynamics;
  extends TRANSFORM.Fluid.Interfaces.Records.Medium_fluid;
  TRANSFORM.Fluid.Interfaces.FluidPort_State port_a(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-20,60},{20,100}}, rotation=0),
        iconTransformation(extent={{-10,74},{10,94}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_State port_b(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-20,-100},{20,-60}}, rotation=
           0), iconTransformation(extent={{-10,-94},{10,-74}})));
  parameter SI.Area A "Cross-sectional area";
  parameter SI.Volume V0=0 "Volume at zero level";
  input SI.Pressure p_surface=p_start "Liquid surface/gas pressure"
    annotation (Dialog(group="Inputs"));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction"
    annotation (Dialog(tab="Advanced"));
  parameter Dynamics energyDynamics=Dynamics.DynamicFreeInitial
    "Formulation of energy balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics massDynamics=energyDynamics "Formulation of mass balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  final parameter Dynamics substanceDynamics=massDynamics
    "Formulation of substance balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  parameter Dynamics traceDynamics=massDynamics
    "Formulation of trace substance balances"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Dynamics"));
  input Real g_n=Modelica.Constants.g_n annotation(Dialog(tab="Advanced"));
  // Initialization
  parameter SI.Pressure p_start=1e5 annotation (Dialog(tab="Initialization"));
  parameter SI.Length level_start "Start level"
    annotation (Dialog(tab="Initialization"));
  parameter SI.SpecificEnthalpy h_start=1e5
    annotation (Dialog(tab="Initialization"));
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
  SI.Length level(start=level_start, stateSelect=StateSelect.prefer)
    "Level";
  SI.Volume V "Volume";
  SI.Mass m "Mmass";
  SI.InternalEnergy U "Liquid internal energy";
  Medium.SpecificEnthalpy h(start=h_start, stateSelect=StateSelect.prefer)
    "Specific enthalpy";
  Medium.AbsolutePressure p(start=p_start) "Pressure";
  Medium.ThermodynamicState state=Medium.setState_phX(p_surface, h,Xi)
    "Thermodynamic state";
  Medium.Density d=Medium.density(state) "Density";
  Medium.Temperature T = Medium.temperature(state) "Temperature";
  SI.Mass mXi[Medium.nXi] "Species mass";
  SI.MassFraction Xi[Medium.nXi](start=Medium.reference_X[1:Medium.nXi])
    "Structurally independent mass fractions";
  SIadd.ExtraPropertyExtrinsic mC[Medium.nC] "Trace substance extrinsic value";
  SIadd.ExtraProperty C[Medium.nC](stateSelect=StateSelect.prefer, start=
        C_start) "Trace substance mass-specific value";
  // Mass Balance
  SI.MassFlowRate mb=port_a.m_flow + port_b.m_flow
    "Mass flow rate source/sinks within volumes";
  // Energy Balance
  SI.HeatFlowRate Ub=port_a.m_flow*actualStream(port_a.h_outflow) + port_b.m_flow
      *actualStream(port_b.h_outflow) + Q_flow_internal + Q_gen
    "Energy source/sinks within volumes (e.g., ohmic heating, external convection)";
  // Species Balance
  SI.MassFlowRate mXib[Medium.nXi]={port_a.m_flow*actualStream(port_a.Xi_outflow[
      i]) + port_b.m_flow*actualStream(port_b.Xi_outflow[i]) for i in 1:Medium.nXi}
    "Species mass flow rates source/sinks within volumes";
  // Trace Balance
  SIadd.ExtraPropertyFlowRate mCb[Medium.nC]={port_a.m_flow*actualStream(port_a.C_outflow[
      i]) + port_b.m_flow*actualStream(port_b.C_outflow[i]) + mC_gen[i] +
      mC_flow_internal[i] for i in 1:Medium.nC}
    "Trace flow rate source/sinks within volumes (e.g., chemical reactions, external convection)";
  parameter Boolean use_HeatPort=false "=true to toggle heat port"
    annotation (Dialog(tab="Advanced", group="Heat Transfer"), Evaluate=true);
  input SI.HeatFlowRate Q_gen=0 "Internal heat generation"
    annotation (Dialog(tab="Advanced", group="Heat Transfer"));
  parameter Boolean use_TraceMassPort=false "=true to toggle trace mass port"
    annotation (Dialog(tab="Advanced", group="Trace Mass Transfer"), Evaluate=true);
  parameter SI.MolarMass MMs[Medium.nC]=fill(1, Medium.nC)
    "Trace substances molar mass" annotation (Dialog(
      tab="Advanced",
      group="Trace Mass Transfer",
      enable=use_TraceMassPort));
  input SIadd.ExtraPropertyFlowRate mC_gen[Medium.nC]=fill(0, Medium.nC)
    "Internal trace mass generation"
    annotation (Dialog(tab="Advanced", group="Trace Mass Transfer"));
  HeatAndMassTransfer.Interfaces.HeatPort_State heatPort(T=T, Q_flow=Q_flow_internal) if use_HeatPort annotation (
      Placement(transformation(extent={{74,-10},{94,10}}), iconTransformation(
          extent={{74,-10},{94,10}})));
  HeatAndMassTransfer.Interfaces.MolePort_State traceMassPort(
    nC=Medium.nC,
    C=C .* d ./ MMs,
    n_flow=mC_flow_internal ./ MMs) if use_TraceMassPort annotation (Placement(
        transformation(extent={{50,-70},{70,-50}}), iconTransformation(extent={{
            50,-70},{70,-50}})));
  // Visualization
  parameter Boolean showName=true annotation (Dialog(tab="Visualization"));
protected
  SI.HeatFlowRate Q_flow_internal;
  SIadd.ExtraPropertyFlowRate mC_flow_internal[Medium.nC];
initial equation
  // Mass Balance
  if massDynamics == Dynamics.FixedInitial then
    level = level_start;
  elseif massDynamics == Dynamics.SteadyStateInitial then
    der(level) = 0;
  end if;
  // Energy Balance
  if energyDynamics == Dynamics.FixedInitial then
    h = h_start;
  elseif energyDynamics == Dynamics.SteadyStateInitial then
    der(h) = 0;
  end if;
  // Species Balance
  if substanceDynamics == Dynamics.FixedInitial then
    Xi = X_start[1:Medium.nXi];
  elseif substanceDynamics == Dynamics.SteadyStateInitial then
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
  // Total Quantities
  V = V0 + A*level;
  m = V*d;
  U = m*Medium.specificInternalEnergy(state);
  p = p_surface + d*g_n*0.5*level;
  mC = m*C;
  // Mass Balance
  if massDynamics == Dynamics.SteadyState then
    0 = mb;
  else
    der(m) = mb;
  end if;
  // Energy Balance
  if massDynamics == Dynamics.SteadyState then
    0 = Ub;
  else
    der(U) = Ub;
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
  // Boundary Conditions
  port_a.p = p_surface;
  port_b.p = p_surface + d*g_n*level;
  port_a.h_outflow = h;
  port_b.h_outflow = h;
  port_a.Xi_outflow = Xi;
  port_b.Xi_outflow = Xi;
  port_a.C_outflow = C;
  port_b.C_outflow = C;
  annotation (defaultComponentName="tank",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
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
          extent={{-150,20},{150,-20}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true, showName),
          origin={-111,0},
          rotation=90)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
<p>Tank where port_a is assumped to empty at the liquid surface level (regardless of level), i.e., port_a.p=p_surface.</p>
<p>p = p_surface + 0.5*fluid pressure</p>
<p>port_b.p = p_surface + fluid pressure</p>
</html>"));
end DumpTank;
