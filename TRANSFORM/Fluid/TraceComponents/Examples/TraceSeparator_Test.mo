within TRANSFORM.Fluid.TraceComponents.Examples;
model TraceSeparator_Test
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;

  replaceable package Medium = Modelica.Media.IdealGases.SingleGases.He (
        extraPropertiesNames=fill("dummy",4)) constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium properties" annotation (
      choicesAllMatching=true);

  replaceable package Medium_carrier =
      Modelica.Media.IdealGases.SingleGases.He (
       extraPropertiesNames=fill("dummy",4),
  C_nominal=fill(1e6,Medium_carrier.nC)) constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium properties" annotation (
      choicesAllMatching=true);

  TRANSFORM.Fluid.TraceComponents.TraceSeparator traceSeparator(
    redeclare package Medium = Medium,
    redeclare package Medium_carrier = Medium_carrier,
    iSep={2,4},
    m_flow_sepFluid=2*source_carrier.m_flow,
    eta={0.2,0.8},
    iCar={4,3})
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T source(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=1,
    T=293.15,
    C=fill(1, Medium.nC))
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T source_carrier(
    redeclare package Medium = Medium_carrier,
    nPorts=1,
    m_flow=0.1,
    T=303.15)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT sink(
    redeclare package Medium = Medium,
    nPorts=1,
    p=100000,
    T=293.15)
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT sink_sepFluid(
    redeclare package Medium = Medium,
    nPorts=1,
    p=100000,
    T=293.15)
    annotation (Placement(transformation(extent={{60,-40},{40,-20}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT sink_carrier(
    redeclare package Medium = Medium_carrier,
    nPorts=1,
    p=100000,
    T=303.15)
    annotation (Placement(transformation(extent={{60,-70},{40,-50}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=5, x=cat(
        1,
        traceSeparator.port_b_carrier.C_outflow,
        {traceSeparator.port_sepFluid.m_flow}))
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(source_carrier.ports[1], traceSeparator.port_a_carrier) annotation (
      Line(points={{-40,-30},{-26,-30},{-26,-6},{-10,-6}}, color={0,127,255}));
  connect(source.ports[1], traceSeparator.port_a)
    annotation (Line(points={{-40,0},{-26,0},{-26,6},{-10,6}},
                                               color={0,127,255}));
  connect(traceSeparator.port_b, sink.ports[1])
    annotation (Line(points={{10,6},{26,6},{26,0},{40,0}},
                                             color={0,127,255}));
  connect(sink_sepFluid.ports[1], traceSeparator.port_sepFluid) annotation (
      Line(points={{40,-30},{26,-30},{26,-1},{10,-1}}, color={0,127,255}));
  connect(sink_carrier.ports[1], traceSeparator.port_b_carrier) annotation (
      Line(points={{40,-60},{24,-60},{24,-6},{10,-6}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TraceSeparator_Test;
