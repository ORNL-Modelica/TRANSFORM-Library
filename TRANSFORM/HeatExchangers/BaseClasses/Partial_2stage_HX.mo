within TRANSFORM.HeatExchangers.BaseClasses;
partial model Partial_2stage_HX
  replaceable package Medium_1 =
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);
  replaceable package Medium_2 = Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching=true);

  // parallel flow not currently implmented
  parameter Boolean counterCurrent=true annotation (Evaluate=true, enable=false);

  parameter SI.AbsolutePressure p_start_1_condensation=Medium_1.p_default "Pressure"
    annotation (Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_start_1_convection=Medium_1.p_default "Pressure"
    annotation (Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_start_2_convection=Medium_2.p_default "Pressure"
    annotation (Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));
  parameter SI.AbsolutePressure p_start_2_condensation=Medium_2.p_default "Pressure"
    annotation (Dialog(tab="Initialization", group="Start Value: Absolute Pressure"));
  parameter SI.SpecificEnthalpy h_start_1_condensation=Medium_1.h_default "Specific Enthalpy"
    annotation (Dialog(tab="Initialization", group="Start Value: Enthalpy"));
  parameter SI.SpecificEnthalpy h_start_1_convection=Medium_1.h_default "Specific Enthalpy"
    annotation (Dialog(tab="Initialization", group="Start Value: Enthalpy"));
  parameter SI.SpecificEnthalpy h_start_2_convection=Medium_2.h_default "Specfic Enthalpy"
    annotation (Dialog(tab="Initialization", group="Start Value: Enthalpy"));
  parameter SI.SpecificEnthalpy h_start_2_condensation=Medium_2.h_default "Specfic Enthalpy"
    annotation (Dialog(tab="Initialization", group="Start Value: Enthalpy"));
  parameter SI.MassFlowRate m_flow_start_1=0 "Mass flow rate"
    annotation (Dialog(tab="Initialization"));
  parameter SI.MassFlowRate m_flow_start_2=0 "Mass flow rate"
    annotation (Dialog(tab="Initialization"));

  SI.Power Q_flow_convection;
  SI.ThermalConductance UA;
  SI.TemperatureDifference dT_LM;

  SI.Power Q_flow_condensation;
  SI.SpecificEnthalpy h_in_condensation;
  SI.SpecificEnthalpy h_out_condensation;
  //parameter Real effectiveness_condensation = 1.0;

  TRANSFORM.Fluid.Interfaces.FluidPort_State port_a1(
    redeclare package Medium = Medium_1) annotation (Placement(
        transformation(extent={{-110,30},{-90,50}}), iconTransformation(
          extent={{-110,30},{-90,50}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b1(redeclare package Medium =
        Medium_1) annotation (Placement(
        transformation(extent={{90,30},{110,50}}), iconTransformation(extent={{90,
            30},{110,50}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_State port_a2(
    redeclare package Medium = Medium_2) annotation (Placement(
        transformation(extent={{90,-50},{110,-30}}), iconTransformation(
          extent={{90,-50},{110,-30}})));
  TRANSFORM.Fluid.Interfaces.FluidPort_Flow port_b2(redeclare package Medium =
        Medium_2) annotation (Placement(
        transformation(extent={{-110,-50},{-90,-30}}), iconTransformation(
          extent={{-110,-50},{-90,-30}})));
  TRANSFORM.Fluid.Volumes.SimpleVolume volume_1_convection(
    redeclare package Medium = Medium_1,
    p_start=p_start_1_convection,
    use_T_start=false,
    h_start=h_start_1_convection,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=
            V_1_convection),
    use_HeatPort=true)
    annotation (Placement(transformation(extent={{30,50},{50,30}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_1_convection(
      redeclare package Medium = Medium_1, R=R_1_convection)
    annotation (Placement(transformation(extent={{50,50},{70,30}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow boundary_1_convection(use_port=
        true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,70})));
  TRANSFORM.Fluid.Volumes.SimpleVolume volume_2_convection(
    redeclare package Medium = Medium_2,
    p_start=p_start_2_convection,
    use_T_start=false,
    h_start=h_start_2_convection,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=
            V_2_convection),
    use_HeatPort=true)
    annotation (Placement(transformation(extent={{70,-50},{50,-30}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow boundary_2_convection(use_port=
        true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,-70})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance_2_convection(
      redeclare package Medium = Medium_2, R=R_2_convection)
    annotation (Placement(transformation(extent={{50,-50},{30,-30}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_b1(redeclare package
      Medium = Medium_1)
    annotation (Placement(transformation(extent={{70,30},{90,50}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_a2(redeclare package
      Medium = Medium_2)
    annotation (Placement(transformation(extent={{90,-50},{70,-30}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_b2(redeclare package
      Medium = Medium_2)
    annotation (Placement(transformation(extent={{30,-30},{10,-50}})));
  Modelica.Blocks.Sources.RealExpression boundary_2_input_convection(y=
        Q_flow_convection)
    annotation (Placement(transformation(extent={{24,-94},{44,-74}})));
  Modelica.Blocks.Sources.RealExpression boundary_1_input_convection(y=-
        Q_flow_convection)
    annotation (Placement(transformation(extent={{80,70},{60,90}})));

  input Units.HydraulicResistance R_1_condensation=1 "Hydraulic resistance"
    annotation (Dialog(group="Inputs"));
  input Units.HydraulicResistance R_1_convection=1 "Hydraulic resistance"
    annotation (Dialog(group="Inputs"));
  input Units.HydraulicResistance R_2_condensation=1 "Hydraulic resistance"
    annotation (Dialog(group="Inputs"));
  input Units.HydraulicResistance R_2_convection=1 "Hydraulic resistance"
    annotation (Dialog(group="Inputs"));
  input SI.Volume V_1_condensation = 0.0 "Volume" annotation (Dialog(group="Inputs"));
  input SI.Volume V_1_convection = 0.0 "Volume" annotation (Dialog(group="Inputs"));
  input SI.Volume V_2_condensation = 0.0 "Volume" annotation (Dialog(group="Inputs"));
  input SI.Volume V_2_convection = 0.0 "Volume" annotation (Dialog(group="Inputs"));
  SI.QualityFactor condensate_quality;
  SI.SpecificEnthalpy h_f;
  SI.SpecificEnthalpy h_g;
  SI.SpecificEnthalpy h_fg;
  Real convection_effectiveness;
  Fluid.Volumes.SimpleVolume volume_1_condensation(
    redeclare package Medium = Medium_1,
    p_start=p_start_1_condensation,
    use_T_start=false,
    h_start=h_start_1_condensation,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=
            V_1_condensation),
    use_HeatPort=true)
    annotation (Placement(transformation(extent={{-70,50},{-50,30}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow boundary_1_condensation(use_port=
        true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-60,70})));
  Modelica.Blocks.Sources.RealExpression boundary_1_input_condensation(y=-
        Q_flow_condensation)
    annotation (Placement(transformation(extent={{-20,70},{-40,90}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_1_condensation(
      redeclare package Medium = Medium_1, R=R_1_condensation)
    annotation (Placement(transformation(extent={{-50,50},{-30,30}})));
  Fluid.Volumes.SimpleVolume volume_2_condensation(
    redeclare package Medium = Medium_2,
    p_start=p_start_2_condensation,
    use_T_start=false,
    h_start=h_start_2_condensation,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=
            V_2_condensation),
    use_HeatPort=true)
    annotation (Placement(transformation(extent={{-50,-50},{-70,-30}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance_2_condensation(
      redeclare package Medium = Medium_2, R=R_2_condensation)
    annotation (Placement(transformation(extent={{-70,-50},{-90,-30}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow boundary_2_condensation(use_port=
        true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-70})));
  Modelica.Blocks.Sources.RealExpression boundary_2_input_condensation(y=
        Q_flow_condensation)
    annotation (Placement(transformation(extent={{-96,-94},{-76,-74}})));
  Fluid.Sensors.SpecificEnthalpyTwoPort sensor_h_in_condensation(redeclare
      package Medium = Medium_1)
    annotation (Placement(transformation(extent={{-90,50},{-70,30}})));
  Fluid.Sensors.PressureTemperatureTwoPort sensor_pT_a1(redeclare package
      Medium = Medium_1)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
equation

  Q_flow_convection = UA*dT_LM*convection_effectiveness;
  dT_LM = TRANSFORM.HeatExchangers.Utilities.Functions.logMean(sensor_pT_a1.T -
    sensor_T_b1.T, sensor_T_b2.T - sensor_T_a2.T);

  Q_flow_condensation = -volume_1_condensation.port_b.m_flow*(h_in_condensation-h_out_condensation);
  h_in_condensation   = sensor_h_in_condensation.h_out;
  h_f  = Medium_1.specificEnthalpy(Medium_1.setBubbleState(Medium_1.setSat_p(sensor_pT_a1.p)));
  h_g  = Medium_1.specificEnthalpy(Medium_1.setDewState(Medium_1.setSat_p(sensor_pT_a1.p)));
  h_fg = h_g-h_f;
  h_out_condensation = h_f + h_fg*condensate_quality;
  connect(volume_1_convection.port_b, resistance_1_convection.port_a)
    annotation (Line(points={{46,40},{53,40}}, color={0,127,255}));
  connect(volume_1_convection.heatPort, boundary_1_convection.port)
    annotation (Line(points={{40,46},{40,60}}, color={191,0,0}));
  connect(volume_2_convection.port_b, resistance_2_convection.port_a)
    annotation (Line(points={{54,-40},{47,-40}}, color={0,127,255}));
  connect(boundary_2_convection.port, volume_2_convection.heatPort)
    annotation (Line(points={{60,-60},{60,-46}}, color={191,0,0}));
  connect(resistance_1_convection.port_b, sensor_T_b1.port_a)
    annotation (Line(points={{67,40},{70,40}}, color={0,127,255}));
  connect(sensor_T_b1.port_b, port_b1)
    annotation (Line(points={{90,40},{100,40}}, color={0,127,255}));
  connect(port_a2, sensor_T_a2.port_a)
    annotation (Line(points={{100,-40},{90,-40}}, color={0,127,255}));
  connect(sensor_T_a2.port_b, volume_2_convection.port_a)
    annotation (Line(points={{70,-40},{66,-40}}, color={0,127,255}));
  connect(resistance_2_convection.port_b, sensor_T_b2.port_a)
    annotation (Line(points={{33,-40},{30,-40}}, color={0,127,255}));
  connect(boundary_2_input_convection.y, boundary_2_convection.Q_flow_ext)
    annotation (Line(points={{45,-84},{60,-84},{60,-74}}, color={0,0,127}));
  connect(boundary_1_input_convection.y, boundary_1_convection.Q_flow_ext)
    annotation (Line(points={{59,80},{40,80},{40,74}}, color={0,0,127}));
  connect(volume_1_condensation.port_b, resistance_1_condensation.port_a)
    annotation (Line(points={{-54,40},{-47,40}}, color={0,127,255}));
  connect(boundary_1_condensation.port, volume_1_condensation.heatPort)
    annotation (Line(points={{-60,60},{-60,46}}, color={191,0,0}));
  connect(boundary_1_input_condensation.y, boundary_1_condensation.Q_flow_ext)
    annotation (Line(points={{-41,80},{-60,80},{-60,74}}, color={0,0,127}));
  connect(sensor_T_b2.port_b, volume_2_condensation.port_a)
    annotation (Line(points={{10,-40},{-54,-40}}, color={0,127,255}));
  connect(volume_2_condensation.port_b, resistance_2_condensation.port_a)
    annotation (Line(points={{-66,-40},{-73,-40}}, color={0,127,255}));
  connect(resistance_2_condensation.port_b, port_b2)
    annotation (Line(points={{-87,-40},{-100,-40}}, color={0,127,255}));
  connect(boundary_2_condensation.port, volume_2_condensation.heatPort)
    annotation (Line(points={{-60,-60},{-60,-46}}, color={191,0,0}));
  connect(boundary_2_condensation.Q_flow_ext, boundary_2_input_condensation.y)
    annotation (Line(points={{-60,-74},{-60,-84},{-75,-84}}, color={0,0,127}));
  connect(sensor_h_in_condensation.port_b, volume_1_condensation.port_a)
    annotation (Line(points={{-70,40},{-66,40}}, color={0,127,255}));
  connect(sensor_h_in_condensation.port_a, port_a1)
    annotation (Line(points={{-90,40},{-100,40}}, color={0,127,255}));
  connect(sensor_pT_a1.port_a, resistance_1_condensation.port_b)
    annotation (Line(points={{-10,40},{-33,40}}, color={0,127,255}));
  connect(sensor_pT_a1.port_b, volume_1_convection.port_a)
    annotation (Line(points={{10,40},{34,40}}, color={0,127,255}));
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
    Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-92,20},{-10,-20}},
          textColor={28,108,200},
          textString="Condensation zone"), Text(
          extent={{8,20},{90,-20}},
          textColor={28,108,200},
          textString="Convection zone")}),
    Documentation(info="<html>
<p>Assumption:</p>
<p>Side 1 is hot side (i.e,. if Q_flow &lt; 0 then heat is going from Side 1 to Side 2)</p>
</html>"));
end Partial_2stage_HX;
