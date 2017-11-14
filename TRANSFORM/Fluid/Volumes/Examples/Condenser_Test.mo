within TRANSFORM.Fluid.Volumes.Examples;
model Condenser_Test

  extends TRANSFORM.Icons.Example;

  Volumes.Condenser                          cond(
    diameter=3,
    use_T_start=false,
    h_start=467114,
    p_start=110000)
    annotation (Placement(transformation(extent={{-16,-27},{24,13}}, rotation=0)));
  BoundaryConditions.MassFlowSource_h steamSource(
    use_h_in=true,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_m_flow_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{-87,13},{-65,36}},
          rotation=0)));
  BoundaryConditions.MassFlowSource_h condensateSink(
    use_h_in=false,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    h=0.5e6,
    use_m_flow_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{-79,-72},{-54,-48}},
          rotation=0)));
  Modelica.Blocks.Sources.Constant steamEnthalpy(k=2e6) annotation (Placement(
        transformation(extent={{-119,5},{-102,22}},rotation=0)));
  Modelica.Blocks.Sources.Constant steamMassFlow(k=3) annotation (Placement(
        transformation(extent={{-119,30},{-102,47}},
                                                   rotation=0)));
  BoundaryConditions.MassFlowSource_h coolFlow(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    use_m_flow_in=true,
    h=coolFlow.Medium.specificEnthalpy(coolFlow.Medium.setState_pTX(
        1.01e5,
        275.54,
        coolFlow.Medium.X_default)),
    nPorts=1) annotation (Placement(transformation(extent={{86,10},{66,30}},
          rotation=0)));
  BoundaryConditions.Boundary_ph coolSink(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=101325,
    h=1e5,
    nPorts=1) annotation (Placement(transformation(extent={{88,-30},{68,-10}},
          rotation=0)));
  Modelica.Blocks.Continuous.FirstOrder neg(
    T=1,
    k=-1.0,
    y_start=-3,
    initType=Modelica.Blocks.Types.Init.SteadyState) annotation (Placement(
        transformation(extent={{-51,-33},{-67,-17}}, rotation=0)));

  Modelica.Blocks.Sources.Ramp coolingMassFlow(
    height=30,
    duration=10,
    offset=30,
    startTime=500)
    annotation (Placement(transformation(extent={{99,41},{83,57}})));
  Sensors.MassFlowRate                       massFlowRate(redeclare package
      Medium = Modelica.Media.Water.StandardWater)
    annotation (Placement(transformation(extent={{-55,33},{-37,15}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(x={cond.level})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(steamEnthalpy.y, steamSource.h_in) annotation (Line(points={{-101.15,
          13.5},{-89.2,13.5},{-89.2,29.1}},    color={0,0,127}));
  connect(massFlowRate.m_flow, neg.u) annotation (Line(
      points={{-46,14.1},{-46,-25},{-49.4,-25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(steamMassFlow.y, steamSource.m_flow_in) annotation (Line(points={{
          -101.15,38.5},{-94.575,38.5},{-94.575,33.7},{-87,33.7}}, color={0,0,
          127}));
  connect(coolingMassFlow.y, coolFlow.m_flow_in) annotation (Line(points={{82.2,
          49},{97,49},{97,28},{86,28}}, color={0,0,127}));
  connect(massFlowRate.port_a, steamSource.ports[1]) annotation (Line(points={{
          -55,24},{-60,24},{-60,24.5},{-65,24.5}}, color={0,127,255}));
  connect(neg.y, condensateSink.m_flow_in) annotation (Line(points={{-67.8,-25},
          {-91,-25},{-91,-50.4},{-79,-50.4}}, color={0,0,127}));
  connect(massFlowRate.port_b, cond.feed)
    annotation (Line(points={{-37,24},{-10,24},{-10,7}}, color={0,127,255}));
  connect(condensateSink.ports[1], cond.drain)
    annotation (Line(points={{-54,-60},{4,-60},{4,-27}}, color={0,127,255}));
  connect(coolSink.ports[1], cond.drain_cool) annotation (Line(points={{68,-20},
          {57,-20},{57,-19},{39,-19},{39,-11},{26,-11}}, color={0,127,255}));
  connect(coolFlow.ports[1], cond.feed_cool) annotation (Line(points={{66,20},
          {52,20},{52,19},{38,19},{38,1},{26,1}}, color={0,127,255}));
  annotation (
    experiment(StopTime=1000, Tolerance=1e-008),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4>Description</h4>
<p>Example demonstrating the condenser component.</p>
<p>At time=500 there is an increase of the cooling mass flow rate. This will result in an increase of the cooling effect and an decrease in the saturation pressure and temperature.</p>
<p>There is also an inital dynamic transient in the beginning of the simulation due to the model is not initialised in steady state.</p>
<h4>Simulation setup</h4>
<p>Simulate for 1000s using Dassl and tolerance 1e-5.</p>
<h4>Output</h4>
<p>Variables of interest are found in the summary record in the condenser component.</p>
</html>"));
end Condenser_Test;