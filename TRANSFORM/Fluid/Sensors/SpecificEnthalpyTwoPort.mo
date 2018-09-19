within TRANSFORM.Fluid.Sensors;
model SpecificEnthalpyTwoPort
  "Ideal two port sensor for the specific enthalpy"
  extends BaseClasses.PartialTwoPortSensor;
  extends BaseClasses.PartialMultiSensor_1values(final var=h_out,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.SpecificEnergy_J_kg.to_J_kg
      constrainedby
      TRANSFORM.Units.Conversions.Functions.SpecificEnergy_J_kg.BaseClasses.to);

  Modelica.Blocks.Interfaces.RealOutput h_out(final quantity="SpecificEnergy",
                                              final unit="J/kg")
    "Specific enthalpy of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,36})));

equation
  if allowFlowReversal then
     h_out = Modelica.Fluid.Utilities.regStep(port_a.m_flow, port_b.h_outflow, port_a.h_outflow, m_flow_small);
  else
     h_out = port_b.h_outflow;
  end if;
  annotation (
    defaultComponentName="sensor_h",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{78,54},{-18,25}},
          lineColor={0,0,0},
          textString="h"),
        Line(points={{50,0},{100,0}}, color={0,128,255}),
        Line(points={{-100,0},{-50,0}}, color={0,128,255})}),
    Documentation(info="<html>
<p>
This component monitors the fluid flowing from port_a to port_b.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end SpecificEnthalpyTwoPort;
