within TRANSFORM.Electrical.Sensors;
model PowerSensor "Measures power flow through the component (port_a to port_b is default direction)"

  extends BaseClasses.PartialRotationIcon_withValueIndicator(final var=W,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.Power_W.to_W
      constrainedby
      TRANSFORM.Units.Conversions.Functions.Power_W.BaseClasses.to);

  TRANSFORM.Electrical.Interfaces.ElectricalPowerPort_Flow port_a annotation (
      Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=0)));
  TRANSFORM.Electrical.Interfaces.ElectricalPowerPort_Flow port_b annotation (
      Placement(transformation(extent={{90,-10},{110,10}},rotation=0),
        iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput W
    "Power flowing from port_a to port_b" annotation (Placement(
        transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,110})));
equation
  port_a.W + port_b.W = 0;
  port_a.f = port_b.f;
  W = port_a.W;
  annotation (defaultComponentName="sensorW",
                     Icon(graphics={
        Text(
          extent={{-149,-68},{151,-108}},
          lineColor={238,46,47},
          textString="%name"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={255,0,0}),
        Line(points={{70,0},{100,0}}, color={255,0,0}),
        Text(
          extent={{18,104},{-78,75}},
          lineColor={0,0,0},
          textString="W")}));
end PowerSensor;
