within TRANSFORM.Media.LookupTableMedianew.Examples;
model LookupTable_Test

  //package Medium = TRANSFORM.Media.LookupTableMedianew.ParaHydrogen;
   //package Medium = Modelica.Media.IdealGases.SingleGases.H2;
  package Medium = TRANSFORM.Media.ExternalMedia.CoolProp.ParaHydrogen;

  Fluid.BoundaryConditions.Boundary_pT boundary(
    redeclare package Medium = Medium,
    p=100000,
    T=293.15,                                   nPorts=1)
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary1(
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=0.1,
    T=293.15,                                         nPorts=1)
    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));
  Fluid.Volumes.SimpleVolume volume(
    redeclare package Medium = Medium,
    p_start=100000,
    T_start=293.15)
    annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance(redeclare package Medium =
               Medium, R=1)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Constant p(k=1e5)
    annotation (Placement(transformation(extent={{100,10},{80,30}})));
  Modelica.Blocks.Sources.Ramp T(
    height=5000,
    duration=1,
    offset=50)
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
equation
  connect(boundary1.ports[1], volume.port_a)
    annotation (Line(points={{-48,0},{-32,0}}, color={0,127,255}));
  connect(volume.port_b, resistance.port_a)
    annotation (Line(points={{-20,0},{3,0}}, color={0,127,255}));
  connect(resistance.port_b, boundary.ports[1])
    annotation (Line(points={{17,0},{50,0}}, color={0,127,255}));
  connect(T.y, boundary1.T_in) annotation (Line(points={{-79,-20},{-76,-20},{-76,
          4},{-70,4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LookupTable_Test;
