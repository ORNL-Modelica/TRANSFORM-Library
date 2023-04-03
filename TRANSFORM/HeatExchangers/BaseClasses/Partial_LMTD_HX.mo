within TRANSFORM.HeatExchangers.BaseClasses;
partial model Partial_LMTD_HX
  replaceable package Medium_1 = Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching=true);
  replaceable package Medium_2 = Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching=true);

  // parallel flow not currently implmented
  parameter Boolean counterCurrent=true annotation (Evaluate=true, enable=false);

  parameter SI.AbsolutePressure p_start_1=Medium_1.p_default "Pressure"
    annotation (Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_start_2=Medium_2.p_default "Pressure"
    annotation (Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));
  parameter SI.Temperature T_start_1=Medium_1.T_default "Temperature"
    annotation (Dialog(tab="Initialization", group="Start Value: Temperature"));
  parameter SI.Temperature T_start_2=Medium_2.T_default "Temperature"
    annotation (Dialog(tab="Initialization", group="Start Value: Temperature"));
  parameter SI.MassFlowRate m_flow_start_1=0 "Mass flow rate"
    annotation (Dialog(tab="Initialization"));
  parameter SI.MassFlowRate m_flow_start_2=0 "Mass flow rate"
    annotation (Dialog(tab="Initialization"));

  SI.Power Q_flow;
  SI.ThermalConductance UA;
  SI.TemperatureDifference dT_LM;

  TRANSFORM.Fluid.Interfaces.FluidPort_State port_a1(
    redeclare package Medium = Medium_1,
    m_flow(start=m_flow_start_1),
    p(start=volume_1.p_start),
    h_outflow(start=volume_1.h_start)) annotation (Placement(transformation(
          extent={{-110,30},{-90,50}}), iconTransformation(extent={{-110,30},{-90,
            50}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b1(redeclare package Medium =
        Medium_1, m_flow(start=-m_flow_start_1)) annotation (Placement(
        transformation(extent={{90,30},{110,50}}), iconTransformation(extent={{90,
            30},{110,50}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_State port_a2(
    redeclare package Medium = Medium_2,
    m_flow(start=m_flow_start_2),
    p(start=volume_2.p_start)) annotation (Placement(transformation(extent={{90,
            -50},{110,-30}}), iconTransformation(extent={{90,-50},{110,-30}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b2(redeclare package Medium =
        Medium_2, m_flow(start=-m_flow_start_2)) annotation (Placement(
        transformation(extent={{-110,-50},{-90,-30}}), iconTransformation(
          extent={{-110,-50},{-90,-30}})));
  TRANSFORM.Fluid.Volumes.SimpleVolume volume_1(
    redeclare package Medium = Medium_1,
    p_start=p_start_1,
    T_start=T_start_1,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume,
    use_HeatPort=true)
    annotation (Placement(transformation(extent={{-40,50},{-20,30}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_1(redeclare package Medium =
                       Medium_1, R=R_1)
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow boundary_1(use_port=
        true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-30,70})));
  TRANSFORM.Fluid.Volumes.SimpleVolume volume_2(
    redeclare package Medium = Medium_2,
    p_start=p_start_2,
    T_start=T_start_2,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume,
    use_HeatPort=true)
    annotation (Placement(transformation(extent={{40,-30},{20,-50}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow boundary_2(use_port=
        true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={30,-10})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance_2(
      redeclare package Medium = Medium_2, R=R_2)
    annotation (Placement(transformation(extent={{-20,-50},{-40,-30}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_a1(redeclare package Medium =
               Medium_1)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_b1(redeclare package Medium =
               Medium_1)
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_a2(redeclare package Medium =
               Medium_2)
    annotation (Placement(transformation(extent={{80,-50},{60,-30}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_b2(redeclare package Medium =
               Medium_2)
    annotation (Placement(transformation(extent={{-60,-50},{-80,-30}})));
  Modelica.Blocks.Sources.RealExpression boundary_2_input(y=Q_flow)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression boundary_1_input(y=-Q_flow)
    annotation (Placement(transformation(extent={{10,70},{-10,90}})));

  input Units.HydraulicResistance R_1=1 "Hydraulic resistance"
    annotation (Dialog(group="Inputs"));
  input Units.HydraulicResistance R_2=1 "Hydraulic resistance"
    annotation (Dialog(group="Inputs"));

equation

  Q_flow = UA*dT_LM;
  dT_LM = TRANSFORM.HeatExchangers.Utilities.Functions.logMean(sensor_T_a1.T -
    sensor_T_b1.T, sensor_T_b2.T - sensor_T_a2.T);

  connect(volume_1.port_b, resistance_1.port_a)
    annotation (Line(points={{-24,40},{23,40}}, color={0,127,255}));
  connect(volume_1.heatPort, boundary_1.port)
    annotation (Line(points={{-30,46},{-30,60}}, color={191,0,0}));
  connect(volume_2.port_b, resistance_2.port_a)
    annotation (Line(points={{24,-40},{-23,-40}}, color={0,127,255}));
  connect(boundary_2.port, volume_2.heatPort)
    annotation (Line(points={{30,-20},{30,-34}}, color={191,0,0}));
  connect(port_a1, sensor_T_a1.port_a)
    annotation (Line(points={{-100,40},{-80,40}}, color={0,127,255}));
  connect(sensor_T_a1.port_b, volume_1.port_a)
    annotation (Line(points={{-60,40},{-36,40}}, color={0,127,255}));
  connect(resistance_1.port_b, sensor_T_b1.port_a)
    annotation (Line(points={{37,40},{60,40}}, color={0,127,255}));
  connect(sensor_T_b1.port_b, port_b1)
    annotation (Line(points={{80,40},{100,40}}, color={0,127,255}));
  connect(port_a2, sensor_T_a2.port_a)
    annotation (Line(points={{100,-40},{80,-40}}, color={0,127,255}));
  connect(sensor_T_a2.port_b, volume_2.port_a)
    annotation (Line(points={{60,-40},{36,-40}}, color={0,127,255}));
  connect(resistance_2.port_b, sensor_T_b2.port_a)
    annotation (Line(points={{-37,-40},{-60,-40}}, color={0,127,255}));
  connect(sensor_T_b2.port_b, port_b2)
    annotation (Line(points={{-80,-40},{-100,-40}}, color={0,127,255}));
  connect(boundary_2_input.y, boundary_2.Q_flow_ext)
    annotation (Line(points={{11,0},{30,0},{30,-6}}, color={0,0,127}));
  connect(boundary_1_input.y, boundary_1.Q_flow_ext)
    annotation (Line(points={{-11,80},{-30,80},{-30,74}}, color={0,0,127}));
  annotation (
    defaultComponentName="lmtd_HX",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-88,-40},{-60,-40},{-30,0},{0,-40},{30,0},{60,-40},{88,-40}},
            color={28,108,200}),
        Line(points={{-88,40},{-30,40},{0,0},{30,40},{88,40}}, color={238,46,47}),
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true, showName))}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Assumption:</p>
<p>Side 1 is hot side (i.e,. if Q_flow &lt; 0 then heat is going from Side 1 to Side 2)</p>
</html>"));
end Partial_LMTD_HX;
