within TRANSFORM.Fluid.Machines.Examples;
model TurboPump_Test
  BoundaryConditions.Boundary_pT boundary(
    redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2,
    p=100000,
    T=273.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  BoundaryConditions.Boundary_pT boundary1(
    redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2,
    use_p_in=true,
    p=110000,
    T=273.15,
    nPorts=1) annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  TurboPump turboPump(
    redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2,
    p_a_start=100000,
    p_b_start=300000,
    T_a_start=273.15,
    m_flow_start=0.1,
    dp_nominal=10000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J=100, w(start=
          157.07963267949, displayUnit="rpm"))
    annotation (Placement(transformation(extent={{2,24},{22,44}})));
  Modelica.Mechanics.Rotational.Sources.ConstantTorque constantTorque(
      tau_constant=+100)
    annotation (Placement(transformation(extent={{60,30},{40,50}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=0.5e5,
    freqHz=1/100,
    offset=1.1e5)
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Modelica.Mechanics.Rotational.Components.Damper damper(d=10)
    annotation (Placement(transformation(extent={{16,52},{36,72}})));
  Modelica.Mechanics.Rotational.Components.Fixed
                              fixed annotation (Placement(transformation(
          extent={{56,70},{72,86}})));
equation
  connect(turboPump.port_b, boundary1.ports[1])
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  connect(turboPump.port_a, boundary.ports[1])
    annotation (Line(points={{-10,0},{-40,0}}, color={0,127,255}));
  connect(inertia.flange_a, turboPump.shaft)
    annotation (Line(points={{2,34},{0,34},{0,6}}, color={0,0,0}));
  connect(inertia.flange_b, constantTorque.flange)
    annotation (Line(points={{22,34},{32,34},{32,40},{40,40}}, color={0,0,0}));
  connect(sine.y, boundary1.p_in)
    annotation (Line(points={{79,0},{72,0},{72,8},{62,8}}, color={0,0,127}));
  connect(damper.flange_a, inertia.flange_a)
    annotation (Line(points={{16,62},{2,62},{2,34}}, color={0,0,0}));
  connect(fixed.flange, damper.flange_b)
    annotation (Line(points={{64,78},{36,78},{36,62}}, color={0,0,0}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=200, __Dymola_NumberOfIntervals=10000));
end TurboPump_Test;
