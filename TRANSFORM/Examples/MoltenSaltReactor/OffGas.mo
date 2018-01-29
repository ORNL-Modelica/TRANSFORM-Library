within TRANSFORM.Examples.MoltenSaltReactor;
model OffGas

  package Medium_OffGas = Modelica.Media.IdealGases.SingleGases.He (
  extraPropertiesNames={"1","2","3"});

  Fluid.BoundaryConditions.Boundary_pT boundary_OffGas_sink(
    redeclare package Medium = Medium_OffGas,
    p=data_OFFGAS.p_sep_ref + 100,
    nPorts=1,
    T=293.15) annotation (Placement(transformation(extent={{40,-30},{20,-10}})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary_OffGas_source(
    T=data_OFFGAS.T_sep_ref,
    redeclare package Medium = Medium_OffGas,
    C=fill(1, Medium_OffGas.nC),
    nPorts=1)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Data.data_OFFGAS data_OFFGAS
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Fluid.Pipes.TraceDecayAdsorberBed adsorberBed(
    K={1e2,1e3,1e4},
    iC=2,
    nV=10,
    redeclare package Medium = Medium_OffGas,
    Qs_decay=fill(1e5, Medium_OffGas.nC),
    T_a_start=data_OFFGAS.T_sep_ref,
    d_adsorber=data_OFFGAS.d_carbon,
    cp_adsorber=data_OFFGAS.cp_carbon,
    R=data_OFFGAS.dp_carbon/data_OFFGAS.m_flow_sep_He_total,
    tau_res=data_OFFGAS.delay_charcoalBed/1e4)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=2,
    width=1,
    period=2,
    nperiod=1,
    offset=1,
    startTime=50)
    annotation (Placement(transformation(extent={{-120,-22},{-100,-2}})));
equation
  connect(boundary_OffGas_source.ports[1], adsorberBed.port_a)
    annotation (Line(points={{-20,-20},{-10,-20}}, color={0,127,255}));
  connect(adsorberBed.port_b, boundary_OffGas_sink.ports[1])
    annotation (Line(points={{10,-20},{20,-20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OffGas;
