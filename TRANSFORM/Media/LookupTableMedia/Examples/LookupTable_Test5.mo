within TRANSFORM.Media.LookupTableMedia.Examples;
model LookupTable_Test5

  package Medium = TRANSFORM.Media.LookupTableMedia.ParaHydrogen;
   //package Medium = Modelica.Media.IdealGases.SingleGases.H2;
//  package Medium = TRANSFORM.Media.ExternalMedia.CoolProp.ParaHydrogen;

  Fluid.BoundaryConditions.Boundary_pT boundary(
    redeclare package Medium = Medium,
    p=100000,
    T=293.15,                                   nPorts=1)
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  Fluid.BoundaryConditions.MassFlowSource_h boundary1(
    redeclare package Medium = Medium,
    use_h_in=true,
    m_flow=0.1,                                       nPorts=1)
    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
  Fluid.Volumes.SimpleVolume volume(
    redeclare package Medium = Medium,
    p_start=100000,
    T_start=293.15)
    annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance(redeclare package
      Medium = Medium, R=1)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=1e6,
    duration=0.5,
    offset=4.35e6,
    startTime=0.5)
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
equation
  connect(boundary1.ports[1], volume.port_a)
    annotation (Line(points={{-48,0},{-32,0}}, color={0,127,255}));
  connect(volume.port_b, resistance.port_a)
    annotation (Line(points={{-20,0},{3,0}}, color={0,127,255}));
  connect(resistance.port_b, boundary.ports[1])
    annotation (Line(points={{17,0},{50,0}}, color={0,127,255}));
  connect(ramp.y, boundary1.h_in) annotation (Line(points={{-79,10},{-74,10},{-74,
          4},{-70,4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LookupTable_Test5;
