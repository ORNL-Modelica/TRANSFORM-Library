within TRANSFORM.Fluid.TraceComponents.Examples;
model TraceDecayAdsorberBed_sparseMatrix_Test
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.IdealGases.SingleGases.He (
  extraPropertiesNames=cat(1,adsorberBed.data_PG.extraPropertiesNames,adsorberBed.data_ISO.extraPropertiesNames));
  TRANSFORM.Fluid.TraceComponents.TraceDecayAdsorberBed_sparseMatrix
                                                        adsorberBed(
    redeclare package Medium = Medium,
    K={1,10,1e2,1e3,1e4,1e5,1e2,1e3,1e4,1e5},
    nV=10,
    Qs_decay=fill(1e5, Medium.nC),
    tau_res=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_HeatPort=true,
    R=1e5,
    T_a_start=373.15,
    redeclare record Data_PG =
        TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.precursorGroups_6_TRACEdefault,
    redeclare record Data_ISO =
        TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.Isotopes_TeIXeU)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    C=fill(1, Medium.nC),
    nPorts=1,
    use_X_in=false,
    use_C_in=true,
    use_m_flow_in=false,
    m_flow=1,
    T=373.15)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT boundary1(
    p=100000,
    T=293.15,
    redeclare package Medium = Medium,
    nPorts=1)
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Modelica.Blocks.Sources.Step step[Medium.nC](
    height=fill(-0.5, Medium.nC),
    offset=fill(1, Medium.nC),
    each startTime=50)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow_multi
    boundary2(nPorts=adsorberBed.nV, Q_flow=fill(-0, adsorberBed.nV))
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  TRANSFORM.Fluid.Sensors.TraceSubstancesTwoPort_multi sensor_C(redeclare
      package                                                                     Medium = Medium)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(boundary.ports[1], adsorberBed.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(step.y, boundary.C_in) annotation (Line(points={{-79,-10},{-70,-10},{-70,
          -8},{-60,-8}}, color={0,0,127}));
  connect(boundary2.port, adsorberBed.heatPorts)
    annotation (Line(points={{-10,20},{0,20},{0,5}},   color={191,0,0}));
  connect(adsorberBed.port_b, sensor_C.port_a)
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  connect(sensor_C.port_b, boundary1.ports[1])
    annotation (Line(points={{60,0},{80,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100));
end TraceDecayAdsorberBed_sparseMatrix_Test;
