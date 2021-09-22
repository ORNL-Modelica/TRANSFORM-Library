within TRANSFORM.HeatExchangers;
model CondensationHXSmooth "Condensing HX with smoothing functions"
  replaceable package Medium_1 =
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);
  replaceable package Medium_2 =
      Modelica.Media.Interfaces.PartialTwoPhaseMedium
    annotation (choicesAllMatching=true);
  Modelica.Units.SI.Power Q_flow_condensation;
  Modelica.Units.SI.Power Q_flow_condensation_nominal;
  Modelica.Units.SI.SpecificEnthalpy h_in_condensation;
  Modelica.Units.SI.SpecificEnthalpy h_out_condensation;
  Modelica.Units.SI.SpecificEnthalpy h_f;
  Modelica.Units.SI.SpecificEnthalpy h_g;
  Modelica.Units.SI.SpecificEnthalpy h_fg;
  Modelica.Units.SI.Temperature T_sat;
  input Modelica.Units.SI.TemperatureDifference T_range = 5 "Range of condensation smoothing" annotation (Dialog(tab="Condensation", group="Inputs"));
  input Real condensation_quality = 0 annotation (Dialog(tab="Condensation", group="Inputs"));
  input Modelica.Units.SI.HeatFlowRate Q_flow_condensation_max annotation (Dialog(tab="Condensation", group="Inputs"));
  TRANSFORM.Fluid.Volumes.MixingVolume volume_2_condensation(
    redeclare package Medium = Medium_2,
    p_start=p_start_condensation2,
    use_T_start=false,
    h_start=h_start_condensation2,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=
            V_condensation2),
    use_HeatPort=true,
    nPorts_b=1,
    nPorts_a=1)
    annotation (Placement(transformation(extent={{30,-30},{10,-50}})));
  TRANSFORM.Fluid.Volumes.MixingVolume volume_1_condensation(
    redeclare package Medium = Medium_1,
    p_start=p_start_condensation1,
    use_T_start=false,
    h_start=h_start_condensation1,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=
            V_condensation1),
    use_HeatPort=true,
    nPorts_a=1,
    nPorts_b=1)
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow boundary(
      use_port=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-10})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow boundary1(
      use_port=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,10})));
  Modelica.Blocks.Math.Gain negate(k=-1)
    annotation (Placement(transformation(extent={{4,-4},{-4,4}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Q_flow_condensation)
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance_2_condensation(
      redeclare package Medium = Medium_2, R=R_condensation2)
    annotation (Placement(transformation(extent={{-30,-30},{-50,-50}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistance_1_condensation(
      redeclare package Medium = Medium_1, R=R_condensation1)
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Fluid.Sensors.SpecificEnthalpyTwoPort sensor_h(redeclare package Medium =
        Medium_1)
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Fluid.Sensors.PressureTemperatureTwoPort sensor_pT5(redeclare package
      Medium = Medium_1)
    annotation (Placement(transformation(extent={{60,50},{80,30}})));
  Fluid.Interfaces.FluidPort_State           port_a1(redeclare package Medium =
        Medium_1)                         annotation (Placement(
        transformation(extent={{-110,30},{-90,50}}), iconTransformation(
          extent={{-110,30},{-90,50}})));
  Fluid.Interfaces.FluidPort_Flow           port_b2(redeclare package Medium =
        Medium_2)  annotation (Placement(
        transformation(extent={{-110,-50},{-90,-30}}), iconTransformation(
          extent={{-110,-50},{-90,-30}})));
  Fluid.Interfaces.FluidPort_State           port_a2(redeclare package Medium =
        Medium_2)                         annotation (Placement(
        transformation(extent={{90,-50},{110,-30}}), iconTransformation(
          extent={{90,-50},{110,-30}})));
  Fluid.Interfaces.FluidPort_Flow           port_b1(redeclare package Medium =
        Medium_1)  annotation (Placement(
        transformation(extent={{90,30},{110,50}}), iconTransformation(extent={{90,30},
            {110,50}})));

  parameter SI.AbsolutePressure p_start_condensation1
    "Pressure" annotation (Dialog(tab="Initialization", group="Condensation"));
  parameter SI.SpecificEnthalpy h_start_condensation1 "Specific enthalpy"
    annotation (Dialog(tab="Initialization", group="Condensation"));
  input Units.HydraulicResistance R_condensation1 "Hydraulic resistance"
    annotation (Dialog(tab="Condensation", group="Inputs"));
  parameter SI.Volume V_condensation1=0.0 "Volume"
    annotation (Dialog(tab="Condensation", group="Inputs"));

  parameter Units.HydraulicResistance R_condensation2 "Hydraulic resistance"
    annotation (Dialog(tab="Condensation", group="Inputs"));
  parameter SI.Volume V_condensation2=0.0 "Volume"
    annotation (Dialog(tab="Condensation", group="Inputs"));
  parameter SI.AbsolutePressure p_start_condensation2 "Pressure"
    annotation (Dialog(tab="Initialization", group="Condensation"));
  parameter SI.SpecificEnthalpy h_start_condensation2 "Specific enthalpy"
    annotation (Dialog(tab="Initialization", group="Condensation"));

  Fluid.Sensors.TemperatureTwoPort      sensor_T(redeclare package Medium =
        Medium_2)
    annotation (Placement(transformation(extent={{80,-50},{60,-30}})));
  Fluid.Sensors.PressureTemperatureTwoPort
                                        sensor_pT(redeclare package Medium =
        Medium_1)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
equation
  connect(boundary.port, volume_2_condensation.heatPort)
    annotation (Line(points={{20,-20},{20,-34}},   color={191,0,0}));
  connect(boundary1.port, volume_1_condensation.heatPort)
    annotation (Line(points={{-20,20},{-20,34}}, color={191,0,0}));
  connect(boundary1.Q_flow_ext, negate.y) annotation (Line(points={{-20,6},{-20,
          0},{-4.4,0}},    color={0,0,127}));
  connect(realExpression.y, negate.u) annotation (Line(points={{39,0},{4.8,0}},
                           color={0,0,127}));
  connect(boundary.Q_flow_ext, negate.u) annotation (Line(points={{20,-6},{20,
          0},{4.8,0}},                     color={0,0,127}));
  connect(volume_1_condensation.port_a[1], sensor_h.port_b)
    annotation (Line(points={{-26,40},{-30,40}}, color={0,127,255}));
  connect(resistance_1_condensation.port_b, sensor_pT5.port_a)
    annotation (Line(points={{47,40},{60,40}}, color={0,127,255}));

  Q_flow_condensation_nominal = -volume_1_condensation.port_b[1].m_flow*(
    h_in_condensation - h_out_condensation);
  T_sat = Medium_1.saturationTemperature(sensor_pT.p);
  Q_flow_condensation = max(min(Q_flow_condensation_nominal*TRANSFORM.Math.spliceTanh(1,0,T_sat-sensor_T.T-T_range/2,T_range/2),Q_flow_condensation_max),0);
  h_in_condensation   =sensor_h.h_out;
  h_f  =Medium_1.specificEnthalpy(Medium_1.setBubbleState(Medium_1.setSat_p(
    resistance_1_condensation.port_b.p)));
  h_g  =Medium_1.specificEnthalpy(Medium_1.setDewState(Medium_1.setSat_p(
    resistance_1_condensation.port_b.p)));
  h_fg = h_g-h_f;
  h_out_condensation  = h_f+h_fg*condensation_quality;
  connect(resistance_2_condensation.port_a, volume_2_condensation.port_b[1])
    annotation (Line(points={{-33,-40},{14,-40}},  color={0,127,255}));
  connect(resistance_1_condensation.port_a, volume_1_condensation.port_b[1])
    annotation (Line(points={{33,40},{-14,40}},  color={0,127,255}));
  connect(port_b2, resistance_2_condensation.port_b)
    annotation (Line(points={{-100,-40},{-47,-40}}, color={0,127,255}));
  connect(sensor_pT5.port_b, port_b1)
    annotation (Line(points={{80,40},{100,40}}, color={0,127,255}));
  connect(volume_2_condensation.port_a[1], sensor_T.port_b)
    annotation (Line(points={{26,-40},{60,-40}}, color={0,127,255}));
  connect(sensor_T.port_a, port_a2)
    annotation (Line(points={{80,-40},{100,-40}}, color={0,127,255}));
  connect(sensor_h.port_a, sensor_pT.port_b)
    annotation (Line(points={{-50,40},{-60,40}}, color={0,127,255}));
  connect(sensor_pT.port_a, port_a1)
    annotation (Line(points={{-80,40},{-100,40}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillColor={170,255,255},
          fillPattern=FillPattern.CrossDiag),
        Line(points={{-88,-40},{-60,-40},{-30,0},{0,-40},{30,0},{60,-40},{88,
              -40}},
            color={28,108,200},
          thickness=0.5),
        Line(points={{-88,40},{-30,40},{0,0},{30,40},{88,40}},     color={238,
              46,47},
          thickness=0.5),
        Text(
          extent={{-147,-68},{153,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),               Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    experiment(
      StopTime=100,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Dassl"));
end CondensationHXSmooth;
