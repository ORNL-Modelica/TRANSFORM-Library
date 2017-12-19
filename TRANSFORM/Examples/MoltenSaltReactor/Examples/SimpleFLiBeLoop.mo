within TRANSFORM.Examples.MoltenSaltReactor.Examples;
model SimpleFLiBeLoop

  replaceable package Medium =
      TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_pT (
  extraPropertiesNames={"PreGroup_1","PreGroup_2","PreGroup_3","PreGroup_4","PreGroup_5","PreGroup_6"},
  C_nominal={1e6,1e6,1e6,1e6,1e6,1e6});

  parameter SI.Length H = 3.4;
  parameter SI.Length L = 6.296;
  parameter SI.Velocity v=0.4772;
  parameter SI.Length d = sqrt(4*1/1000/v/Modelica.Constants.pi);

  Fluid.Pipes.GenericPipe_MultiTransferSurface           pipe(
    redeclare package Medium = Medium,
    m_flow_a_start=1,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=d,
        length=H,
        nV=10),
    p_a_start=100000,
    T_a_start=573.15,
    T_b_start=773.15,
    redeclare model InternalHeatGen =
        Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
        (Q_gens=kinetics.Qs),
    redeclare model InternalTraceMassGen =
        Fluid.ClosureRelations.InternalMassGeneration.Models.DistributedVolume_TraceMass_1D.GenericMassGeneration
        (mC_gens=kinetics.mC_gens))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,0})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface downcomer(
    redeclare package Medium = Medium,
    m_flow_a_start=1,
    use_HeatTransfer=true,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=d,
        length=L,
        nV=10),
    redeclare model InternalHeatGen =
        Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration,
    redeclare model InternalTraceMassGen =
        Fluid.ClosureRelations.InternalMassGeneration.Models.DistributedVolume_TraceMass_1D.GenericMassGeneration
        (mC_gens={{-kinetics.lambda_i[j]*downcomer.mCs[i, j] for j in 1:
            kinetics.nI} for i in 1:downcomer.nV}),
    p_a_start=100000,
    T_a_start=773.15,
    T_b_start=573.15) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={20,0})));

  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow_multi boundary2(nPorts=
        downcomer.nV, Q_flow=fill(-5e4, boundary2.nPorts))
    annotation (Placement(transformation(extent={{64,-10},{44,10}})));
  Fluid.Sensors.TraceSubstancesTwoPort_multi traceSubstance(redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=270,
        origin={20,-30})));
  Nuclear.ReactorKinetics.PointKinetics_Drift           kinetics(
    nV=pipe.nV,
    Q_nominal=5e4*pipe.nV,
    Ts=pipe.mediums.T,
    mCs=pipe.mCs,
    Ts_reference=linspace(
        300 + 273.15,
        500 + 273.15,
        pipe.nV))
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Fluid.Volumes.ExpansionTank_1Port expansionTank_1Port(
    redeclare package Medium = Medium,
    A=1,
    level_start=0.1,
    T_start=773.15)
    annotation (Placement(transformation(extent={{-30,54},{-10,74}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance(redeclare package
      Medium = Medium, R=1e6) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,40})));
  Fluid.Machines.Pump_SimpleMassFlow pump_SimpleMassFlow(redeclare package
      Medium = Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
equation
  connect(boundary2.port, downcomer.heatPorts[:, 1])
    annotation (Line(points={{44,0},{25,0}}, color={191,0,0}));
  connect(pipe.port_b, downcomer.port_a) annotation (Line(points={{-20,10},{-20,
          20},{20,20},{20,10}}, color={0,127,255}));
  connect(downcomer.port_b, traceSubstance.port_a)
    annotation (Line(points={{20,-10},{20,-20}}, color={0,127,255}));
  connect(resistance.port_a, pipe.port_b)
    annotation (Line(points={{-20,33},{-20,10}}, color={0,127,255}));
  connect(expansionTank_1Port.port, resistance.port_b)
    annotation (Line(points={{-20,55.6},{-20,47}}, color={0,127,255}));
  connect(pump_SimpleMassFlow.port_a, traceSubstance.port_b)
    annotation (Line(points={{10,-60},{20,-60},{20,-40}}, color={0,127,255}));
  connect(pump_SimpleMassFlow.port_b, pipe.port_a) annotation (Line(points={{
          -10,-60},{-20,-60},{-20,-10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1000, __Dymola_NumberOfIntervals=1000));
end SimpleFLiBeLoop;
