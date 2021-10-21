within TRANSFORM.Fluid.Sensors;
model VolumeFlowRate "Ideal sensor for volume flow rate"
  extends BaseClasses.PartialTwoPortSensor;
  extends BaseClasses.PartialMultiSensor_1values(final var=V_flow,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.VolumeFlowRate_m3_s.to_m3_s
      constrainedby TRANSFORM.Units.Conversions.Functions.VolumeFlowRate_m3_s.BaseClasses.to);
  Modelica.Blocks.Interfaces.RealOutput V_flow(final quantity="VolumeFlowRate",
                                               final unit="m3/s")
    "Volume flow rate from port_a to port_b"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,36})));
protected
  Medium.Density rho_a_inflow "Density of inflowing fluid at port_a";
  Medium.Density rho_b_inflow
    "Density of inflowing fluid at port_b or rho_a_inflow, if uni-directional flow";
  Medium.Density d "Density of the passing fluid";
equation
  if allowFlowReversal then
     rho_a_inflow = Medium.density(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow));
     rho_b_inflow = Medium.density(Medium.setState_phX(port_a.p, port_a.h_outflow, port_a.Xi_outflow));
     d = Modelica.Fluid.Utilities.regStep(port_a.m_flow, rho_a_inflow, rho_b_inflow, m_flow_small);
  else
     d = Medium.density(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow));
     rho_a_inflow = d;
     rho_b_inflow = d;
  end if;
  V_flow = port_a.m_flow/d;
  annotation (
    defaultComponentName="sensor_V_flow",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{106,58},{10,29}},
          lineColor={0,0,0},
          textString="V_flow"),
        Line(points={{-100,0},{-50,0}}, color={0,128,255}),
        Line(points={{50,0},{100,0}}, color={0,128,255})}),
    Documentation(info="<html>
<p>
This component monitors the fluid flowing from port_a to port_b.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end VolumeFlowRate;
