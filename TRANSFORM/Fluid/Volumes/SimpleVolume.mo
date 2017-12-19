within TRANSFORM.Fluid.Volumes;
model SimpleVolume

  Interfaces.FluidPort_State port_a(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}}),
        iconTransformation(extent={{-70,-10},{-50,10}})));
  Interfaces.FluidPort_State port_b(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{50,-10},{70,10}}),
        iconTransformation(extent={{50,-10},{70,10}})));

  extends BaseClasses.PartialVolume(
  final V = geometry.V,
  mb=port_a.m_flow + port_b.m_flow,
  Ub=port_a.m_flow*actualStream(port_a.h_outflow) + port_b.m_flow*actualStream(port_b.h_outflow) + Q_flow_internal,
  mXib=port_a.m_flow*actualStream(port_a.Xi_outflow) + port_b.m_flow*actualStream(port_b.Xi_outflow),
  mCb=port_a.m_flow*actualStream(port_a.C_outflow) + port_b.m_flow*actualStream(port_b.C_outflow) + mC_flow_internal);

  // Geometry Model
  replaceable model Geometry =
      TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
    constrainedby
    TRANSFORM.Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume
                                                                          "Geometry"
    annotation (Dialog(group="Geometry"),choicesAllMatching=true);

  Geometry geometry annotation (Placement(transformation(extent={{-78,82},{-62,98}})));

  input SI.Acceleration g_n = Modelica.Constants.g_n "Gravitational acceleration" annotation(Dialog(tab="Advanced",group="Input Variables"));

  parameter Boolean use_HeatPort = false "=true to toggle heat port" annotation(Dialog(tab="Advanced"),Evaluate=true);
  parameter Boolean use_TraceMassPort = false "=true to toggle trace mass port" annotation(Dialog(tab="Advanced"),Evaluate=true);
  parameter SI.MolarMass MMs[Medium.nC]=fill(1, Medium.nC)
    "Trace substances molar mass"
    annotation (Dialog(group="Trace Mass Transfer", enable=use_TraceMassPort));

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
  port_a.p = medium.p + medium.d*g_n*0.5*geometry.dheight;
  port_b.p = medium.p - medium.d*g_n*0.5*geometry.dheight;
  port_a.h_outflow = medium.h;
  port_b.h_outflow = medium.h;
  port_a.Xi_outflow = medium.Xi;
  port_b.Xi_outflow = medium.Xi;
  port_a.C_outflow = C;
  port_b.C_outflow = C;

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
end SimpleVolume;
