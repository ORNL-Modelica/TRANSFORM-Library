within TRANSFORM.HeatAndMassTransfer.Sensors;
model HeatFlowRate "Ideal sensor for heat flow rate"
   extends BaseClasses.PartialTwoPortSensor;
   extends BaseClasses.PartialRotationIcon_withValueIndicator(
       final var=Q_flow, redeclare replaceable function iconUnit =
         TRANSFORM.Units.Conversions.Functions.Power_W.to_W
       constrainedby
      TRANSFORM.Units.Conversions.Functions.Power_W.BaseClasses.to);

   Modelica.Blocks.Interfaces.RealOutput Q_flow(quantity="HeatFlowRate",
                                                final unit="W")
     "Heat flow rate from port_a to port_b" annotation (Placement(
         transformation(
         origin={0,110},
         extent={{10,-10},{-10,10}},
         rotation=270)));

equation
   Q_flow = port_a.Q_flow;
annotation (
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Line(points={{70,0},{100,0}}, color={191,0,0}),
        Text(
          extent={{18,104},{-142,74}},
          lineColor={0,0,0},
          textString="Q_flow"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={191,0,0})}),
  Documentation(info="<html>
<p>
This component monitors the mass flow rate flowing from port_a to port_b.
The sensor is ideal, i.e., it does not influence the flow.
</p>
</html>"));
end HeatFlowRate;
