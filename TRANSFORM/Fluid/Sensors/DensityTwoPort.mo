within TRANSFORM.Fluid.Sensors;
model DensityTwoPort "Ideal two port density sensor"
  extends BaseClasses.PartialTwoPortSensor;
  extends BaseClasses.PartialRotationIcon_withValueIndicator(final var=d,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.Density_kg_m3.to_kg_m3
      constrainedby
      TRANSFORM.Units.Conversions.Functions.Density_kg_m3.BaseClasses.to);

  Modelica.Blocks.Interfaces.RealOutput d(
    final quantity="Density",
    final unit="kg/m3",
    min=0) "Density of the passing fluid" annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));

protected
  Medium.Density rho_a_inflow "Density of inflowing fluid at port_a";
  Medium.Density rho_b_inflow
    "Density of inflowing fluid at port_b or rho_a_inflow, if uni-directional flow";

equation
  if allowFlowReversal then
    rho_a_inflow = Medium.density(Medium.setState_phX(
      port_b.p,
      port_b.h_outflow,
      port_b.Xi_outflow));
    rho_b_inflow = Medium.density(Medium.setState_phX(
      port_a.p,
      port_a.h_outflow,
      port_a.Xi_outflow));
    d = Modelica.Fluid.Utilities.regStep(
      port_a.m_flow,
      rho_a_inflow,
      rho_b_inflow,
      m_flow_small);
  else
    d = Medium.density(Medium.setState_phX(
      port_b.p,
      port_b.h_outflow,
      port_b.Xi_outflow));
    rho_a_inflow = d;
    rho_b_inflow = d;
  end if;
  annotation (
    defaultComponentName="density",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{18,104},{-78,75}},
          lineColor={0,0,0},
          textString="d"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255})}),
    Documentation(info="<html>
<p>
This component monitors the density of the fluid flowing from port_a to port_b.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end DensityTwoPort;
