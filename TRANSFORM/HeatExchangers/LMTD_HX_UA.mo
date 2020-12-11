within TRANSFORM.HeatExchangers;
model LMTD_HX_UA
  "Log mean temperature difference heat exchanger with UA as input"
  replaceable package Medium_Hot =
      Modelica.Media.Air.DryAirNasa
    constrainedby Modelica.Media.Interfaces.PartialMedium
                                    "Heat is removed from"
                                                          annotation (
      choicesAllMatching=true);
  replaceable package Medium_Cold = Modelica.Media.Air.DryAirNasa                     constrainedby
    Modelica.Media.Interfaces.PartialMedium                        "Heat is added to"
                                            annotation (choicesAllMatching=true);

  SI.Power Q_flow;
  input SI.ThermalConductance UA annotation(Dialog(tab="General"));
  input SI.TemperatureDifference dT_LM annotation(Dialog(tab="General"));
  Fluid.Interfaces.FluidPort_State port_a1(redeclare package Medium =
        Medium_Hot) annotation (Placement(transformation(extent={{-110,-50},{-90,
            -30}}), iconTransformation(extent={{-110,-50},{-90,-30}})));
  Fluid.Interfaces.FluidPort_Flow port_b1(redeclare package Medium = Medium_Hot)
    annotation (Placement(transformation(extent={{90,-50},{110,-30}}),
        iconTransformation(extent={{90,-50},{110,-30}})));
  Fluid.Interfaces.FluidPort_State port_a2(redeclare package Medium =
        Medium_Cold) annotation (Placement(transformation(extent={{110,30},{90,
            50}}), iconTransformation(extent={{90,30},{110,50}})));
  Fluid.Interfaces.FluidPort_Flow port_b2(redeclare package Medium =
        Medium_Cold) annotation (Placement(transformation(extent={{-90,30},{-110,
            50}}), iconTransformation(extent={{-110,30},{-90,50}})));
  TRANSFORM.Fluid.Volumes.SimpleVolume volumeHot(redeclare package Medium =
        Medium_Hot, use_HeatPort=true)
    annotation (Placement(transformation(extent={{-50,-30},{-30,-50}})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistanceHot(
      redeclare package Medium = Medium_Hot, R=R_Hot)
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow boundary1(
      use_port=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-10})));
  TRANSFORM.Fluid.Volumes.SimpleVolume volumeCold(redeclare package Medium =
        Medium_Cold, use_HeatPort=true)
    annotation (Placement(transformation(extent={{50,50},{30,30}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow boundary2(
      use_port=true) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={40,70})));
  TRANSFORM.Fluid.FittingsAndResistances.SpecifiedResistance resistanceCold(
      redeclare package Medium = Medium_Cold, R=R_Cold)
    annotation (Placement(transformation(extent={{0,30},{-20,50}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_a1(redeclare package
      Medium = Medium_Hot)
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_b1(redeclare package
      Medium = Medium_Hot)
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_a2(redeclare package
      Medium = Medium_Cold)
    annotation (Placement(transformation(extent={{80,30},{60,50}})));
  TRANSFORM.Fluid.Sensors.TemperatureTwoPort sensor_T_b2(redeclare package
      Medium = Medium_Cold)
    annotation (Placement(transformation(extent={{-60,30},{-80,50}})));
  Modelica.Blocks.Sources.RealExpression boundary2_input(y=Q_flow)
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Modelica.Blocks.Sources.RealExpression boundary1_input(y=-Q_flow)
    annotation (Placement(transformation(extent={{0,-10},{-20,10}})));

  parameter Units.HydraulicResistance R_Hot=1 "Hydraulic resistance"
    annotation (Dialog(tab="General", group="Resistance"));
  parameter Units.HydraulicResistance R_Cold=1 "Hydraulic resistance"
    annotation (Dialog(tab="General", group="Resistance"));
equation
  Q_flow = UA*dT_LM;
  //dT_LM = TRANSFORM.HeatExchangers.Utilities.Functions.logMean(sensor_T_a1.T -
  //  sensor_T_b1.T, sensor_T_b2.T - sensor_T_a2.T);

  connect(volumeHot.port_b, resistanceHot.port_a)
    annotation (Line(points={{-34,-40},{3,-40}}, color={0,127,255}));
  connect(volumeHot.heatPort, boundary1.port)
    annotation (Line(points={{-40,-34},{-40,-20}}, color={191,0,0}));
  connect(boundary2.port, volumeCold.heatPort)
    annotation (Line(points={{40,60},{40,46}},   color={191,0,0}));
  connect(port_a1, sensor_T_a1.port_a)
    annotation (Line(points={{-100,-40},{-80,-40}}, color={0,127,255}));
  connect(sensor_T_a1.port_b, volumeHot.port_a)
    annotation (Line(points={{-60,-40},{-46,-40}}, color={0,127,255}));
  connect(resistanceHot.port_b, sensor_T_b1.port_a)
    annotation (Line(points={{17,-40},{60,-40}}, color={0,127,255}));
  connect(sensor_T_b1.port_b, port_b1)
    annotation (Line(points={{80,-40},{100,-40}}, color={0,127,255}));
  connect(boundary2_input.y, boundary2.Q_flow_ext)
    annotation (Line(points={{21,80},{40,80},{40,74}},    color={0,0,127}));
  connect(boundary1_input.y, boundary1.Q_flow_ext)
    annotation (Line(points={{-21,0},{-40,0},{-40,-6}}, color={0,0,127}));
  connect(sensor_T_a2.port_a, port_a2)
    annotation (Line(points={{80,40},{100,40}}, color={0,127,255}));
  connect(sensor_T_a2.port_b, volumeCold.port_a)
    annotation (Line(points={{60,40},{46,40}}, color={0,127,255}));
  connect(resistanceCold.port_a, volumeCold.port_b)
    annotation (Line(points={{-3,40},{34,40}}, color={0,127,255}));
  connect(resistanceCold.port_b, sensor_T_b2.port_a)
    annotation (Line(points={{-17,40},{-60,40}}, color={0,127,255}));
  connect(sensor_T_b2.port_b, port_b2)
    annotation (Line(points={{-80,40},{-100,40}}, color={0,127,255}));
  annotation (defaultComponentName="lmtd_HX",Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-88,40},{-60,40},{-30,0},{0,40},{30,0},{60,40},{88,40}},
            color={28,108,200}),
        Line(points={{-88,-40},{-30,-40},{0,0},{30,-40},{88,-40}}, color={238,46,
              47}),
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={0,0,255},
          textString="%name",
          visible=DynamicSelect(true,showName))}),               Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Assumption:</p>
<p>Side 1 is hot side (i.e,. if Q_flow &lt; 0 then heat is going from Side 1 to Side 2)</p>
</html>"));
end LMTD_HX_UA;
