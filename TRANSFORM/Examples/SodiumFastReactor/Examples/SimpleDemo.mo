within TRANSFORM.Examples.SodiumFastReactor.Examples;
model SimpleDemo

  package Medium = TRANSFORM.Media.Fluids.Sodium.LinearSodium_pT;
  Fluid.Pipes.GenericPipe_MultiTransferSurface pipe1(
    redeclare package Medium = Medium,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=0.1, nV=5),
    p_a_start=100000,
    T_a_start=573.15,
    use_HeatTransfer=true)
                        annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={20,0})));
  Fluid.Machines.Pump_SimpleMassFlow pump_SimpleMassFlow(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    use_input=true)
    annotation (Placement(transformation(extent={{10,-30},{-10,-50}})));
  Fluid.Volumes.ExpansionTank_1Port expansionTank_1Port(
    level_start=1,
    A=1,
    use_T_start=true,
    T_start=573.15,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance(redeclare package
              Medium =
               Medium, R=1)                                   annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,30})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=0.5,
    offset=1,
    freqHz=1/100)
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow_multi boundary(
    nPorts=5,
    use_port=false,
    Q_flow=fill(-1e3, 5))
    annotation (Placement(transformation(extent={{56,-10},{36,10}})));
  Nuclear.CoreSubchannels.Regions_1 coreSubchannel(
    redeclare package Medium = Medium,
    redeclare package Material_1 = Media.Solids.UO2,
    redeclare model Geometry =
        Nuclear.ClosureRelations.Geometry.Models.CoreSubchannels.Generic (nV=5,
          dimension=0.1),
    Q_nominal=1e4,
    CR_reactivity=sine1.y,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,

    Teffref_fuel=673.15,
    Teffref_coolant=623.15,
    T_start_1=673.15,
    p_a_start=100000,
    T_a_start=573.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,0})));

  Modelica.Blocks.Sources.Sine sine1(
    freqHz=1/50,
    startTime=200,
    amplitude=0.01)
    annotation (Placement(transformation(extent={{-100,-12},{-80,8}})));
equation
  connect(pump_SimpleMassFlow.port_a, pipe1.port_b)
    annotation (Line(points={{10,-40},{20,-40},{20,-10}}, color={0,127,255}));
  connect(expansionTank_1Port.port, resistance.port_b)
    annotation (Line(points={{0,51.6},{0,37}}, color={0,127,255}));
  connect(resistance.port_a, pipe1.port_a) annotation (Line(points={{0,23},{0,20},
          {20,20},{20,10}}, color={0,127,255}));
  connect(sine.y, pump_SimpleMassFlow.in_m_flow)
    annotation (Line(points={{-19,-70},{0,-70},{0,-47.3}}, color={0,0,127}));
  connect(boundary.port, pipe1.heatPorts[:, 1])
    annotation (Line(points={{36,0},{25,0}}, color={191,0,0}));
  connect(pump_SimpleMassFlow.port_b, coreSubchannel.port_a) annotation (Line(
        points={{-10,-40},{-20,-40},{-20,-10}}, color={0,127,255}));
  connect(coreSubchannel.port_b, pipe1.port_a) annotation (Line(points={{-20,10},
          {-20,20},{20,20},{20,10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1000));
end SimpleDemo;
