within TRANSFORM.Examples.MoltenSaltReactor;
model OffGas

  package Medium_OffGas = Modelica.Media.IdealGases.SingleGases.He (
  extraPropertiesNames={"1","2","3"});

  Fluid.BoundaryConditions.Boundary_pT boundary(nPorts=2,
    redeclare package Medium = Medium_OffGas,
    p=100000,
    T=293.15)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary1(m_flow=data_OFFGAS.m_flow_sep_He_total,
      T=data_OFFGAS.T_sep_ref,
    nPorts=1,
    redeclare package Medium = Medium_OffGas)
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Data.data_OFFGAS data_OFFGAS
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Fluid.FittingsAndResistances.TeeJunctionVolume teeJunctionVolume(redeclare
      package Medium = Medium_OffGas, V=0)                         annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-12,-20})));
  Fluid.FittingsAndResistances.SpecifiedResistance toBubbler(redeclare package
      Medium = Medium_OffGas, R=100)
    annotation (Placement(transformation(extent={{-20,30},{-40,50}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance(R=1, redeclare
      package Medium = Medium_OffGas)
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Fluid.Pipes.TraceDecayAdsorberBed adsorberBed(
    K={1e2,1e3,1e4},
    iC=2,
    nV=10,
    redeclare package Medium = Medium_OffGas,
    Qs_decay=fill(1e5, Medium_OffGas.nC),
    dp=100000)
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
equation
  connect(boundary1.ports[1], teeJunctionVolume.port_3)
    annotation (Line(points={{-60,-20},{-22,-20}}, color={0,127,255}));
  connect(teeJunctionVolume.port_2, toBubbler.port_a)
    annotation (Line(points={{-12,-10},{-12,40},{-23,40}}, color={0,127,255}));
  connect(toBubbler.port_b, boundary.ports[1])
    annotation (Line(points={{-37,40},{-48,40},{-48,42},{-60,42}},
                                                 color={0,127,255}));
  connect(teeJunctionVolume.port_1, resistance.port_a) annotation (Line(points={
          {-12,-30},{-12,-40},{-7,-40}}, color={0,127,255}));
  connect(resistance.port_b, adsorberBed.port_a)
    annotation (Line(points={{7,-40},{20,-40}}, color={0,127,255}));
  connect(adsorberBed.port_b, boundary.ports[2]) annotation (Line(points={{40,
          -40},{48,-40},{48,46},{-60,46},{-60,38}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OffGas;
