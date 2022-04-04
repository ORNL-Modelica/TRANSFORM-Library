within TRANSFORM.Fluid.FittingsAndResistances.Examples;
model ElevationChange
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  Modelica.Fluid.Sources.FixedBoundary OUT_mflow(
    p=system.p_ambient,
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,0})));
  Modelica.Fluid.Sources.MassFlowSource_T IN_mflow(
    T=system.T_ambient,
    nPorts=1,
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    use_m_flow_in=false)                                      annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,0})));
  inner Modelica.Fluid.System system(p_ambient(displayUnit="Pa") = 100000,
      m_flow_small=0.01) annotation (Placement(transformation(extent={{80, -100}, {100, -80}})));
  TRANSFORM.Fluid.FittingsAndResistances.ElevationChange from_mflow(redeclare
      package Medium = Modelica.Media.Air.DryAirNasa, dheight=dh.y)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp dh(
    startTime=0,
    duration=0.5,
    height=20,
    offset=-10)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
equation
  connect(IN_mflow.ports[1], from_mflow.port_a) annotation (Line(points={{-40,0},
          {-7,0}},                   color={0,127,255}));
  connect(from_mflow.port_b, OUT_mflow.ports[1])
    annotation (Line(points={{7,0},{7,0},{40,0}},         color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(Interval=0.0002));
end ElevationChange;
