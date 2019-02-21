within TRANSFORM.Fluid.FittingsAndResistances.Examples;
model GasKineticTheoryTest
  extends TRANSFORM.Icons.Example;
  GasKineticTheory        resistance(redeclare package Medium =
        Modelica.Media.Water.StandardWater, surfaceArea=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  BoundaryConditions.Boundary_pT boundary(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=100000,
    T=373.15)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  BoundaryConditions.Boundary_pT boundary1(
    nPorts=1,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p=1000000,
    T=293.15) annotation (Placement(transformation(extent={{60,-10},{40,10}})));
equation
  connect(boundary.ports[1], resistance.port_a)
    annotation (Line(points={{-40,0},{-7,0}}, color={0,127,255}));
  connect(resistance.port_b, boundary1.ports[1])
    annotation (Line(points={{7,0},{40,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end GasKineticTheoryTest;
