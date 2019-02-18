within TRANSFORM.Fluid.Valves.Examples;
model CompressibleValve2_Test
  extends TRANSFORM.Icons.Example;
  replaceable package Medium =
      TRANSFORM.Media.ExternalMedia.CoolProp.Hydrogen;
  ExternalMedia.Media.BaseClasses.ExternalTwoPhaseMedium.ThermodynamicState state_x = Medium.setState_ph(valveCompressible2.port_a.p,valveCompressible2.port_a.h_outflow);
  Real gamma = Medium.specificHeatCapacityCp(state_x)/Medium.specificHeatCapacityCv(state_x);
  Real xReal = (2/(gamma+1))^(gamma/(gamma-1));
  TRANSFORM.Fluid.Valves.ValveCompressible2 valveCompressible2(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal(displayUnit="Pa") = 1000,
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
  Modelica.Blocks.Sources.Constant positionValve(k=1)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    nperiod=1,
    amplitude=-6.99e6,
    offset=7e6,
    startTime=1,
    period=100,
    rising=15,
    falling=15,
    width=0)    annotation (Placement(transformation(extent={{96,-2},{76,18}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid1(
    nperiod=1,
    amplitude=-6.99e6,
    offset=7e6,
    period=100,
    rising=15,
    falling=15,
    width=0,
    startTime=31)
    annotation (Placement(transformation(extent={{-94,-18},{-74,2}})));
equation
  connect(positionValve.y, valveCompressible2.opening)
    annotation (Line(points={{-19,30},{0,30},{0,8}}, color={0,0,127}));
  connect(H2_Inlet.ports[1], valveCompressible2.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(valveCompressible2.port_b, H2_outlet.ports[1])
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  connect(trapezoid1.y, H2_Inlet.p_in)
    annotation (Line(points={{-73,-8},{-62,-8}}, color={0,0,127}));
  connect(H2_outlet.p_in, trapezoid.y)
    annotation (Line(points={{62,8},{75,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=70));
end CompressibleValve2_Test;
