within TRANSFORM.Fluid.Volumes;
model MixingVolume

  parameter Integer nPorts_a=0 "Number of port_a connections"
    annotation (Dialog(connectorSizing=true));
  parameter Integer nPorts_b=0 "Number of port_b connections"
    annotation (Dialog(connectorSizing=true));

  Interfaces.FluidPort_State port_a[nPorts_a](redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}}),
        iconTransformation(extent={{-70,-10},{-50,10}})));
  Interfaces.FluidPort_State port_b[nPorts_b](redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{50,-10},{70,10}}),
        iconTransformation(extent={{50,-10},{70,10}})));

  extends BaseClasses.PartialVolume(
  final V = geometry.V,
  mb=sum(port_a.m_flow) + sum(port_b.m_flow),
  Ub=sum(H_flows_a) + sum(H_flows_b) + Q_flow_internal,
  mXib={sum(mXi_flows_a[:, i]) + sum(mXi_flows_b[:, i]) for i in 1:Medium.nXi},
  mCb={sum(mC_flows_a[:, i]) + sum(mC_flows_b[:, i]) + mC_flow_internal[i] + mC_gen[i] for i in 1:Medium.nC});

  // Geometry Model
  replaceable model Geometry =
      TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
                                                                          "Geometry"
    annotation (Dialog(group="Geometry"),choicesAllMatching=true);

  Geometry geometry annotation (Placement(transformation(extent={{-78,82},{-62,98}})));

  input SI.Acceleration g_n = Modelica.Constants.g_n "Gravitational acceleration" annotation(Dialog(tab="Advanced",group="Input Variables"));

  SI.HeatFlowRate H_flows_a[nPorts_a] "Enthalpy flow rates at port_a";
  SI.MassFlowRate mXi_flows_a[nPorts_a,Medium.nXi]
    "Species mass flow rates at port_a";
  SI.MassFlowRate mC_flows_a[nPorts_a,Medium.nC]
    "Trace substance mass flow rates at port_a";

  SI.HeatFlowRate H_flows_b[nPorts_b] "Enthalpy flow rates at port_b";
  SI.MassFlowRate mXi_flows_b[nPorts_b,Medium.nXi]
    "Species mass flow rates at port_b";
  SI.MassFlowRate mC_flows_b[nPorts_b,Medium.nC]
    "Trace substance mass flow rates at port_b";

  parameter Boolean use_HeatPort = false "=true to toggle heat port" annotation(Dialog(tab="Advanced"),Evaluate=true);
  parameter Boolean use_TraceMassPort = false "=true to toggle trace mass port" annotation(Dialog(tab="Advanced"),Evaluate=true);
  parameter SI.MolarMass MMs[Medium.nC]=fill(1, Medium.nC)
    "Trace substances molar mass"
    annotation (Dialog(group="Trace Mass Transfer", enable=use_TraceMassPort));
  input SI.MassFlowRate mC_gen[Medium.nC]=fill(0,Medium.nC) "Internal trace mass generation"
    annotation (Dialog(group="Trace Mass Transfer"));
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

  // Visualization
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));

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

  // Boundary Conditions
  port_a.p = fill(medium.p + medium.d*g_n*0.5*geometry.dheight, nPorts_a);
  port_b.p = fill(medium.p - medium.d*g_n*0.5*geometry.dheight, nPorts_b);
  port_a.h_outflow = fill(medium.h, nPorts_a);
  port_b.h_outflow = fill(medium.h, nPorts_b);
  port_a.Xi_outflow = fill(medium.Xi, nPorts_a);
  port_b.Xi_outflow = fill(medium.Xi, nPorts_b);
  port_a.C_outflow = fill(C, nPorts_a);
  port_b.C_outflow = fill(C, nPorts_b);

  for i in 1:nPorts_a loop
    H_flows_a[i] = port_a[i].m_flow*actualStream(port_a[i].h_outflow);
    mXi_flows_a[i, :] = port_a[i].m_flow*actualStream(port_a[i].Xi_outflow);
    mC_flows_a[i, :] = port_a[i].m_flow*actualStream(port_a[i].C_outflow);
  end for;

  for i in 1:nPorts_b loop
    H_flows_b[i] = port_b[i].m_flow*actualStream(port_b[i].h_outflow);
    mXi_flows_b[i, :] = port_b[i].m_flow*actualStream(port_b[i].Xi_outflow);
    mC_flows_b[i, :] = port_b[i].m_flow*actualStream(port_b[i].C_outflow);
  end for;

  annotation (
    defaultComponentName="volume",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Ellipse(
          extent={{60,60},{-60,-60}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Sphere),
        Text(
          extent={{-151,104},{149,64}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end MixingVolume;
