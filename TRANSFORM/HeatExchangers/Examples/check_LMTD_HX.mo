within TRANSFORM.HeatExchangers.Examples;
model check_LMTD_HX
extends TRANSFORM.Icons.Example;
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T boundary_a2(
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    m_flow=2.2,
    T=298.15,
    nPorts=1) annotation (Placement(transformation(extent={{-62,-30},{-42,-10}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T boundary_a1(
    redeclare package Medium =
        Modelica.Media.IdealGases.SingleGases.He,
    m_flow=0.38,
    T=698.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT boundary_b2(
    redeclare package Medium = Modelica.Media.Air.DryAirNasa,
    p=100000,
    T=523.15,
    nPorts=1) annotation (Placement(transformation(extent={{62,-30},{42,-10}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT boundary_b1(
    redeclare package Medium =
        Modelica.Media.IdealGases.SingleGases.He,
    p=6000000,
    T=573.15,
    nPorts=1) annotation (Placement(transformation(extent={{64,10},{44,30}})));
  TRANSFORM.HeatExchangers.LMTD_HX_A lmtd_HX
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(boundary_a1.ports[1], lmtd_HX.port_a1) annotation (Line(points={{-40,20},
          {-16,20},{-16,4},{-10,4}},    color={0,127,255}));
  connect(boundary_a2.ports[1], lmtd_HX.port_a2) annotation (Line(points={{-42,-20},
          {-16,-20},{-16,-4},{-10,-4}},
                                     color={0,127,255}));
  connect(boundary_b2.ports[1], lmtd_HX.port_b2) annotation (Line(points={{42,-20},
          {16,-20},{16,-4},{10,-4}},
                                  color={0,127,255}));
  connect(boundary_b1.ports[1], lmtd_HX.port_b1) annotation (Line(points={{44,20},
          {16,20},{16,4},{10,4}},    color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end check_LMTD_HX;
