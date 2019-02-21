within TRANSFORM.Fluid.Sensors.BaseClasses;
model stateSensor
  "fluid data sensor - should be connected to MultiDisplayPanel to visualization of fluid state parameters"
  extends TRANSFORM.Icons.UnderConstruction;
  extends Sensors.BaseClasses.PartialTwoPortSensor;
  parameter Boolean use_Display = true "true to enable display panel";
  Modelica.Fluid.Sensors.Pressure pressure(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{10,9},{30,29}})));
  Modelica.Fluid.Sensors.Temperature temperature(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{10,-31},{30,-11}})));
  Modelica.Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-29,-30},{-9,-10}})));
  Modelica.Fluid.Sensors.SpecificEnthalpy specificEnthalpy(redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{-30,9},{-10,29}})));
  TRANSFORM.Fluid.Sensors.BaseClasses.statePort statePort annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}), iconTransformation(extent={{
            -10,20},{10,40}})));
equation
connect(pressure.port,port_a);
connect(temperature.port,port_a);
connect(port_a,massFlowRate.port_a);
connect(massFlowRate.port_b,port_b);
connect(specificEnthalpy.port,port_a);
// connect(statePort.p,pressure.p);
// connect(statePort.T,temperature.T);
// connect(statePort.m_flow,massFlowRate.m_flow);
// connect(statePort.h_out,specificEnthalpy.h_out);
statePort.p=pressure.p;
statePort.T=temperature.T;
statePort.m_flow=massFlowRate.m_flow;
statePort.h_out=specificEnthalpy.h_out;
  annotation (
        Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
        Polygon(points={{-68,0},{-68,0}}, lineColor={28,108,200}),
                   Polygon(
                points={{-100,0},{0,32},{100,0},{0,-32},{-100,0}},
                fillColor={28,108,200},
                fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-34,16},{34,-10}},
          lineColor={255,255,255},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          textString="State")}),
      Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})));
end stateSensor;
