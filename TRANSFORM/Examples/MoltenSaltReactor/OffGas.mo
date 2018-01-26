within TRANSFORM.Examples.MoltenSaltReactor;
model OffGas

  package Medium_OffGas = Modelica.Media.IdealGases.SingleGases.He (
  extraPropertiesNames={"1","2","3"});

  Fluid.BoundaryConditions.Boundary_pT boundary(
    redeclare package Medium = Medium_OffGas,
    p=100000,
    T=293.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{100,-30},{80,-10}})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary1(m_flow=data_OFFGAS.m_flow_sep_He_total,
      T=data_OFFGAS.T_sep_ref,
    redeclare package Medium = Medium_OffGas,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Data.data_OFFGAS data_OFFGAS
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Fluid.Pipes.TraceDecayAdsorberBed adsorberBed(
    K={1e2,1e3,1e4},
    iC=2,
    nV=10,
    redeclare package Medium = Medium_OffGas,
    Qs_decay=fill(1e5, Medium_OffGas.nC),
    T_a_start=data_OFFGAS.T_sep_ref,
    tau_res=data_OFFGAS.delay_charcoalBed,
    d_adsorber=data_OFFGAS.d_carbon,
    cp_adsorber=data_OFFGAS.cp_carbon,
    R=data_OFFGAS.dp_carbon/data_OFFGAS.m_flow_sep_He_total)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
equation
  connect(boundary1.ports[1], adsorberBed.port_a)
    annotation (Line(points={{-60,-20},{-10,-20}}, color={0,127,255}));
  connect(adsorberBed.port_b, boundary.ports[1])
    annotation (Line(points={{10,-20},{80,-20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OffGas;
