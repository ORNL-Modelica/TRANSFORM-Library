within TRANSFORM.Fluid.Sensors;
model SpecificEntropyTwoPort "Ideal two port sensor for the specific entropy"
  extends BaseClasses.PartialTwoPortSensor;
  extends BaseClasses.PartialMultiSensor_1values(final var=s,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.SpecificHeatAndEntropy_J_kgK.to_J_kgK
      constrainedby
      TRANSFORM.Units.Conversions.Functions.SpecificEntropy_J_kgK.BaseClasses.to);
  Modelica.Blocks.Interfaces.RealOutput s(final quantity="SpecificEntropy",
                                          final unit="J/(kg.K)")
    "Specific entropy of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,36})));
protected
  Medium.SpecificEntropy s_a_inflow
    "Specific entropy of inflowing fluid at port_a";
  Medium.SpecificEntropy s_b_inflow
    "Specific entropy of inflowing fluid at port_b or s_a_inflow, if uni-directional flow";
equation
  if allowFlowReversal then
     s_a_inflow = Medium.specificEntropy(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow));
     s_b_inflow = Medium.specificEntropy(Medium.setState_phX(port_a.p, port_a.h_outflow, port_a.Xi_outflow));
     s = Modelica.Fluid.Utilities.regStep(port_a.m_flow, s_a_inflow, s_b_inflow, m_flow_small);
  else
     s = Medium.specificEntropy(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow));
     s_a_inflow = s;
     s_b_inflow = s;
  end if;
  annotation (
    defaultComponentName="sensor_s",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{78,56},{-18,27}},
          lineColor={0,0,0},
          textString="s"),
        Line(points={{50,0},{100,0}}, color={0,128,255}),
        Line(points={{-100,0},{-50,0}}, color={0,128,255})}),
    Documentation(info="<html>
<p>
This component monitors the fluid flowing from port_a to port_b.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end SpecificEntropyTwoPort;
