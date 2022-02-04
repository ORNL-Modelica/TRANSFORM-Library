within TRANSFORM.Fluid.Valves.Nozzles;
model NozzleTest
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.IdealGases.SingleGases.H2;
  SimpleNozzle simpleNozzle(
    redeclare package Medium = Medium,
    dp_nominal=6999000,
    m_flow_nominal=1,
    rho_nominal=Medium.density_pT(simpleNozzle.p_nominal, 2500),
    p_nominal=7000000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT boundary(
    redeclare package Medium = Medium,
    use_T_in=true,
    p=7000000,
    T(displayUnit="K") = 2500,                                           nPorts=
       1) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT boundary1(
    redeclare package Medium = Medium,
    p(displayUnit="bar") = 1000,
            nPorts=1)
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=1)
    annotation (Placement(transformation(extent={{-30,34},{-10,54}})));
  Modelica.Blocks.Interaction.Show.RealValue realValue(
    use_numberPort=false,
    number=simpleNozzle.Isp,
    significantDigits=5)
    annotation (Placement(transformation(extent={{-20,-46},{20,-26}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=500,
    freqHz=10,
    offset=2200,
    startTime=0.1)
    annotation (Placement(transformation(extent={{-96,-6},{-76,14}})));
equation
  connect(boundary.ports[1], simpleNozzle.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(simpleNozzle.port_b, boundary1.ports[1])
    annotation (Line(points={{10,0},{26,0},{26,0},{40,0}}, color={0,127,255}));
  connect(realExpression.y, simpleNozzle.opening)
    annotation (Line(points={{-9,44},{0,44},{0,8}}, color={0,0,127}));
  connect(sine.y, boundary.T_in)
    annotation (Line(points={{-75,4},{-62,4}}, color={0,0,127}));
end NozzleTest;
