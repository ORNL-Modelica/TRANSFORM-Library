within TRANSFORM.Fluid.Valves.Examples;
model CompressibleValve2_Test2
  extends TRANSFORM.Icons.Example;
  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2;
  Medium.ThermodynamicState state_x = Medium.setState_ph(valveCompressible2.port_a.p,valveCompressible2.port_a.h_outflow);
  Real gamma = Medium.specificHeatCapacityCp(state_x)/Medium.specificHeatCapacityCv(state_x);
  Real xReal = (2/(gamma+1))^(gamma/(gamma-1));
  TRANSFORM.Fluid.Valves.ValveCompressible2 valveCompressible2(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal(displayUnit="Pa") = 1000,
    filteredOpening=false,
    riseTime=10,
    p_nominal(displayUnit="Pa") = 7e6)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT      H2_Inlet(
    redeclare package Medium = Medium,
    use_p_in=true,
    use_T_in=false,
    T(displayUnit="K") = 1000,
    nPorts=1)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-50,0})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT H2_outlet(
    redeclare package Medium = Medium,
    T(displayUnit="K") = 1000,
    p(displayUnit="Pa") = 10000,
    use_p_in=true,
    nPorts=1)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,0})));
  Modelica.Blocks.Sources.Sine positionValve(
    amplitude=0.49,
    f=1/10,
    offset=0.5,
    startTime=0.5)
    annotation (Placement(transformation(extent={{-90,58},{-70,78}})));
  Modelica.Blocks.Sources.Constant  const1(k=6.9e6)
                annotation (Placement(transformation(extent={{96,-2},{76,18}})));
  Modelica.Blocks.Sources.Constant  const(k=7e6)
    annotation (Placement(transformation(extent={{-94,-18},{-74,2}})));
  Modelica.Blocks.Continuous.Der der1
    annotation (Placement(transformation(extent={{-34,58},{-14,78}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=0.2)
    annotation (Placement(transformation(extent={{2,58},{22,78}})));
  Modelica.Blocks.Continuous.Integrator integrator(y_start=0.5)
    annotation (Placement(transformation(extent={{34,58},{54,78}})));
equation
  connect(H2_Inlet.ports[1], valveCompressible2.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(valveCompressible2.port_b, H2_outlet.ports[1])
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  connect(const.y, H2_Inlet.p_in)
    annotation (Line(points={{-73,-8},{-62,-8}}, color={0,0,127}));
  connect(H2_outlet.p_in, const1.y)
    annotation (Line(points={{62,8},{75,8}}, color={0,0,127}));
  connect(der1.y, limiter.u)
    annotation (Line(points={{-13,68},{0,68}}, color={0,0,127}));
  connect(limiter.y, integrator.u)
    annotation (Line(points={{23,68},{32,68}}, color={0,0,127}));
  connect(positionValve.y, der1.u)
    annotation (Line(points={{-69,68},{-36,68}}, color={0,0,127}));
  connect(integrator.y, valveCompressible2.opening) annotation (Line(points={{
          55,68},{66,68},{66,36},{0,36},{0,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=70));
end CompressibleValve2_Test2;
