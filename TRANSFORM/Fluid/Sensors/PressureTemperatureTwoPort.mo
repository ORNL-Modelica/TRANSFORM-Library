within TRANSFORM.Fluid.Sensors;
model PressureTemperatureTwoPort
  "Ideal two port pressure and temperature sensor"
  extends BaseClasses.PartialTwoPortSensor;
  extends BaseClasses.PartialMultiSensor_2values(                    final var=p,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.Pressure_Pa.to_MPa
      constrainedby
      TRANSFORM.Units.Conversions.Functions.Pressure_Pa.BaseClasses.to,final var2=T,
      redeclare replaceable function iconUnit2 =
        TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC
      constrainedby
      TRANSFORM.Units.Conversions.Functions.Temperature_K.BaseClasses.to);
  Modelica.Blocks.Interfaces.RealOutput p(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="bar",
    min=0) "Pressure at port"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
        iconTransformation(extent={{50,14},{70,34}})));
  Modelica.Blocks.Interfaces.RealOutput T(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min=0,
    displayUnit="degC") "Temperature of the passing fluid" annotation (
      Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={60,-20})));
protected
  Medium.Temperature T_a_inflow "Temperature of inflowing fluid at port_a";
  Medium.Temperature T_b_inflow
    "Temperature of inflowing fluid at port_b or T_a_inflow, if uni-directional flow";
equation
p = port_a.p;

  if allowFlowReversal then
    T_a_inflow = Medium.temperature(Medium.setState_phX(
      port_b.p,
      port_b.h_outflow,
      port_b.Xi_outflow));
    T_b_inflow = Medium.temperature(Medium.setState_phX(
      port_a.p,
      port_a.h_outflow,
      port_a.Xi_outflow));
    T = Modelica.Fluid.Utilities.regStep(
      port_a.m_flow,
      T_a_inflow,
      T_b_inflow,
      m_flow_small);
  else
    T = Medium.temperature(Medium.setState_phX(
      port_b.p,
      port_b.h_outflow,
      port_b.Xi_outflow));
    T_a_inflow = T;
    T_b_inflow = T;
  end if;
  annotation (
    defaultComponentName="sensor_pT",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{120,-40},{24,-69}},
          lineColor={0,0,0},
          textString="T"),
        Line(points={{50,0},{100,0}}, color={0,128,255}),
        Line(points={{-100,0},{-50,0}}, color={0,128,255}),
        Text(
          extent={{120,70},{24,41}},
          lineColor={0,0,0},
          textString="p")}),
    Documentation(info="<html>
<p>
This component monitors the fluid flowing from port_a to port_b.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end PressureTemperatureTwoPort;
