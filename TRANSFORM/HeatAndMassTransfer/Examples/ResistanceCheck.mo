within TRANSFORM.HeatAndMassTransfer.Examples;
model ResistanceCheck
  extends Icons.Example;

  Resistances.Heat.Plane plane(
    L=L.y,
    crossArea=crossArea.y,
    lambda=lambda.y)
    annotation (Placement(transformation(extent={{-60,4},{-40,24}})));
  Resistances.Heat.Cylinder cylinder(
    L=L.y,
    r_in=r_in.y,
    r_out=r_out.y,
    lambda=lambda.y)
    annotation (Placement(transformation(extent={{-60,-26},{-40,-6}})));
  Resistances.Heat.Sphere sphere(
    r_in=r_in.y,
    r_out=r_out.y,
    lambda=lambda.y)
    annotation (Placement(transformation(extent={{-60,-56},{-40,-36}})));
  Resistances.Heat.Convection convection(surfaceArea=surfaceArea.y, alpha=alpha.y)
    annotation (Placement(transformation(extent={{-60,-86},{-40,-66}})));
  Resistances.Heat.Contact contact(surfaceArea=surfaceArea.y, Rc_pp=Rc_pp.y)
    annotation (Placement(transformation(extent={{40,4},{60,24}})));
  Resistances.Heat.Radiation radiationExact(surfaceArea=surfaceArea.y, epsilon=
        epsilon.y)
    annotation (Placement(transformation(extent={{40,-26},{60,-6}})));
  Resistances.Heat.Radiation radiationApproximate(
    useExact=false,
    surfaceArea=surfaceArea.y,
    epsilon=epsilon.y)
    annotation (Placement(transformation(extent={{40,-56},{60,-36}})));

  Modelica.Blocks.Sources.Constant L(k=1)
    annotation (Placement(transformation(extent={{-100,68},{-90,78}})));
  Modelica.Blocks.Sources.Constant surfaceArea(k=2)
    annotation (Placement(transformation(extent={{-60,68},{-50,78}})));
  Modelica.Blocks.Sources.Constant crossArea(k=2)
    annotation (Placement(transformation(extent={{-80,68},{-70,78}})));
  Modelica.Blocks.Sources.Constant r_in(k=1)
    annotation (Placement(transformation(extent={{-100,50},{-90,60}})));
  Modelica.Blocks.Sources.Constant lambda(k=5)
    annotation (Placement(transformation(extent={{-60,86},{-50,96}})));
  Modelica.Blocks.Sources.Constant r_out(k=2)
    annotation (Placement(transformation(extent={{-80,50},{-70,60}})));
  Modelica.Blocks.Sources.Constant T_a(k=293.15)
    annotation (Placement(transformation(extent={{-100,86},{-90,96}})));
  Modelica.Blocks.Sources.Constant T_b(k=313.15)
    annotation (Placement(transformation(extent={{-80,86},{-70,96}})));
  Modelica.Blocks.Sources.Constant epsilon(k=0.5)
    annotation (Placement(transformation(extent={{-40,68},{-30,78}})));
  Modelica.Blocks.Sources.Constant Rc_pp(k=5)
    annotation (Placement(transformation(extent={{-60,50},{-50,60}})));
  Modelica.Blocks.Sources.Constant alpha(k=15)
    annotation (Placement(transformation(extent={{-40,86},{-30,96}})));

  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_a1(T(
        displayUnit="degC") = T_a.k)
    annotation (Placement(transformation(extent={{-90,4},{-70,24}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_b1(T(
        displayUnit="degC") = T_b.k)
    annotation (Placement(transformation(extent={{-10,4},{-30,24}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_a2(T(
        displayUnit="degC") = T_a.k)
    annotation (Placement(transformation(extent={{-90,-26},{-70,-6}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_b2(T(
        displayUnit="degC") = T_b.k)
    annotation (Placement(transformation(extent={{-10,-26},{-30,-6}})));

  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_a3(T(
        displayUnit="degC") = T_a.k)
    annotation (Placement(transformation(extent={{-90,-56},{-70,-36}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_b3(T(
        displayUnit="degC") = T_b.k)
    annotation (Placement(transformation(extent={{-10,-56},{-30,-36}})));

  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_a4(T(
        displayUnit="degC") = T_a.k)
    annotation (Placement(transformation(extent={{-90,-86},{-70,-66}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_b4(T(
        displayUnit="degC") = T_b.k)
    annotation (Placement(transformation(extent={{-10,-86},{-30,-66}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_a5(T(
        displayUnit="degC") = T_a.k)
    annotation (Placement(transformation(extent={{10,4},{30,24}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_b5(T(
        displayUnit="degC") = T_b.k)
    annotation (Placement(transformation(extent={{90,4},{70,24}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_a6(T(
        displayUnit="degC") = T_a.k)
    annotation (Placement(transformation(extent={{10,-26},{30,-6}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_b6(T(
        displayUnit="degC") = T_b.k)
    annotation (Placement(transformation(extent={{90,-26},{70,-6}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_a7(T(
        displayUnit="degC") = T_a.k)
    annotation (Placement(transformation(extent={{10,-56},{30,-36}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_b7(T(
        displayUnit="degC") = T_b.k)
    annotation (Placement(transformation(extent={{90,-56},{70,-36}})));

  Resistances.Heat.SemiInfinitePlane plane_semiInf(
    crossArea=crossArea.y,
    lambda=lambda.y,
    alpha_d=alpha_d.y,
    t=1) annotation (Placement(transformation(extent={{40,-86},{60,-66}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_a8(T(
        displayUnit="degC") = T_a.k)
    annotation (Placement(transformation(extent={{10,-86},{30,-66}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_b8(T(
        displayUnit="degC") = T_b.k)
    annotation (Placement(transformation(extent={{90,-86},{70,-66}})));
  Modelica.Blocks.Sources.Constant alpha_d(k=1)
    annotation (Placement(transformation(extent={{-20,86},{-10,96}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=8, x={plane.port_b.Q_flow,
        cylinder.port_b.Q_flow,sphere.port_b.Q_flow,convection.port_b.Q_flow,
        contact.port_b.Q_flow,radiationExact.port_b.Q_flow,radiationApproximate.port_b.Q_flow,
        plane_semiInf.port_b.Q_flow})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(plane.port_b, T_b1.port) annotation (Line(
      points={{-43,14},{-36.5,14},{-30,14}},
      color={191,0,0},
      thickness=0.5));
  connect(plane.port_a, T_a1.port) annotation (Line(
      points={{-57,14},{-63.5,14},{-70,14}},
      color={191,0,0},
      thickness=0.5));
  connect(cylinder.port_b, T_b2.port) annotation (Line(
      points={{-43,-16},{-36.5,-16},{-30,-16}},
      color={191,0,0},
      thickness=0.5));
  connect(T_a2.port, cylinder.port_a) annotation (Line(
      points={{-70,-16},{-57,-16},{-57,-16}},
      color={191,0,0},
      thickness=0.5));
  connect(T_a3.port, sphere.port_a) annotation (Line(
      points={{-70,-46},{-57,-46},{-57,-46}},
      color={191,0,0},
      thickness=0.5));
  connect(T_b3.port, sphere.port_b) annotation (Line(
      points={{-30,-46},{-43,-46},{-43,-46}},
      color={191,0,0},
      thickness=0.5));
  connect(T_b4.port, convection.port_b) annotation (Line(
      points={{-30,-76},{-43,-76},{-43,-76}},
      color={191,0,0},
      thickness=0.5));
  connect(T_a4.port, convection.port_a) annotation (Line(
      points={{-70,-76},{-57,-76},{-57,-76}},
      color={191,0,0},
      thickness=0.5));
  connect(T_a5.port, contact.port_a) annotation (Line(
      points={{30,14},{43,14},{43,14}},
      color={191,0,0},
      thickness=0.5));
  connect(T_a6.port, radiationExact.port_a) annotation (Line(
      points={{30,-16},{43,-16},{43,-16}},
      color={191,0,0},
      thickness=0.5));
  connect(T_a7.port, radiationApproximate.port_a) annotation (Line(
      points={{30,-46},{43,-46},{43,-46}},
      color={191,0,0},
      thickness=0.5));
  connect(T_a8.port, plane_semiInf.port_a) annotation (Line(
      points={{30,-76},{43,-76},{43,-76}},
      color={191,0,0},
      thickness=0.5));
  connect(plane_semiInf.port_b, T_b8.port) annotation (Line(
      points={{57,-76},{63.5,-76},{70,-76}},
      color={191,0,0},
      thickness=0.5));
  connect(radiationApproximate.port_b, T_b7.port) annotation (Line(
      points={{57,-46},{64,-46},{64,-46},{70,-46}},
      color={191,0,0},
      thickness=0.5));
  connect(radiationExact.port_b, T_b6.port) annotation (Line(
      points={{57,-16},{63.5,-16},{70,-16}},
      color={191,0,0},
      thickness=0.5));
  connect(contact.port_b, T_b5.port) annotation (Line(
      points={{57,14},{70,14},{70,14}},
      color={191,0,0},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=100));
end ResistanceCheck;
