within TRANSFORM.Fluid.Volumes.InProgress;
model Pressurizer_Test
  extends Modelica.Icons.Example;

  TRANSFORM.Fluid.Volumes.InProgress.Pressurizer_withWall pressurizer(
    redeclare model BulkCondensation =
        Volumes.ClosureModels.MassTransfer.Condensation.ConstantTimeDelay (tau=
            15),
    cp_wall=600,
    rho_wall=7000,
    V_wall=2/3*pi*((3.105 + 0.14)^3 - 3.105^3),
    V_total=pi*1.596^2*1.109 + pi*3.105^2*0.19 + 2/3*pi*3.105^3,
    redeclare model DrumType =
        Volumes.ClosureModels.Geometry.DrumTypes.Integral (
        r_1=1.596,
        r_2=3.105,
        r_3=3.105,
        h_1=1.109,
        h_2=0.19),
    p_start(displayUnit="MPa"),
    redeclare model BulkEvaporation =
        Volumes.ClosureModels.MassTransfer.Evaporation.ConstantTimeDelay (tau=
            15),
    redeclare model MassTransfer_VL =
        Volumes.ClosureModels.MassTransfer.PhaseInterface.ConstantMassTransportCoefficient
        (alphaD0=0.001),
    redeclare model HeatTransfer_VL =
        Volumes.ClosureModels.MassTransfer.PhaseInterface.ConstantHeatTransferCoefficient
        (alpha0=100),
    redeclare model HeatTransfer_WL =
        BaseClasses.ClosureModels.HeatTransfer.ConstantHeatTransferCoefficient,
    redeclare model HeatTransfer_WV =
        BaseClasses.ClosureModels.HeatTransfer.ConstantHeatTransferCoefficient,
    Vfrac_liquid_start=1/3)
    annotation (Placement(transformation(extent={{-20,-26},{20,26}})));

  Modelica.Fluid.Sources.MassFlowSource_h spray(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    h=400e3,
    m_flow=0,
    nPorts=1)
             annotation (Placement(transformation(extent={{-68,50},{-48,70}})));
  Modelica.Fluid.Sources.MassFlowSource_h relief(          redeclare package
      Medium = Modelica.Media.Water.StandardWater,
    h=relief.Medium.dewEnthalpy(relief.Medium.setSat_p(system.p_start)),
    nPorts=1)
    annotation (Placement(transformation(extent={{68,50},{48,70}})));
  Modelica.Fluid.Sources.MassFlowSource_T fromCore(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1,
    m_flow=system.m_flow_start,
    T=system.T_start)
    annotation (Placement(transformation(extent={{-88,-90},{-68,-70}})));
  Modelica.Blocks.Sources.Constant liquidHeaterSource(k=0)
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow liquidHeater
    annotation (Placement(transformation(extent={{-66,-30},{-46,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Temp_walLiquid(T=348.15)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.Constant vaporHeaterSource(k=0)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow vaporHeater
    annotation (Placement(transformation(extent={{-66,10},{-46,30}})));
  inner TRANSFORM.Fluid.System system(
    p_start(displayUnit="MPa") = 15500000,
    m_flow_start=4712,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Fluid.Fittings.TeeJunctionVolume teeJunctionVolume(
    V=38.73,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p_start(displayUnit="MPa"))
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Modelica.Fluid.Sources.Boundary_pT toPump(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p(displayUnit="MPa") = system.p_start,
    T=system.T_start,
    nPorts=1)
    annotation (Placement(transformation(extent={{90,-90},{70,-70}})));
  FittingsAndResistances.SpecifiedResistance lineToPressurizer(R=1, redeclare
      package Medium = Modelica.Media.Water.StandardWater) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-52})));
  FittingsAndResistances.SpecifiedResistance lineToPump(redeclare package
      Medium = Modelica.Media.Water.StandardWater, R=1) annotation (Placement(
        transformation(
        extent={{10,9.5},{-10,-9.5}},
        rotation=180,
        origin={36.5,-80})));
equation
  connect(vaporHeaterSource.y, vaporHeater.Q_flow)
    annotation (Line(points={{-79,20},{-79,20},{-66,20}},   color={0,0,127}));
  connect(liquidHeaterSource.y, liquidHeater.Q_flow) annotation (Line(points={{-79,-20},
          {-79,-20},{-66,-20}},            color={0,0,127}));
  connect(spray.ports[1], pressurizer.sprayPort)
    annotation (Line(points={{-48,60},{-12,60},{-12,26}}, color={0,127,255}));
  connect(relief.ports[1], pressurizer.reliefPort)
    annotation (Line(points={{48,60},{12,60},{12,26}}, color={0,127,255}));
  connect(Temp_walLiquid.port, pressurizer.heatTransfer_wall)
    annotation (Line(points={{60,0},{20,0}},        color={191,0,0}));
  connect(fromCore.ports[1], teeJunctionVolume.port_1) annotation (Line(points={{-68,-80},
          {-40,-80},{-10,-80}},            color={0,127,255}));
  connect(vaporHeater.port, pressurizer.vaporHeater) annotation (Line(points={{-46,
          20},{-40,20},{-40,10.4},{-20,10.4}}, color={191,0,0}));
  connect(liquidHeater.port, pressurizer.liquidHeater) annotation (Line(points={
          {-46,-20},{-40,-20},{-40,-10.4},{-20,-10.4}}, color={191,0,0}));
  connect(lineToPressurizer.port_a, pressurizer.surgePort)
    annotation (Line(points={{0,-45},{0,-26}},         color={0,127,255}));
  connect(lineToPressurizer.port_b, teeJunctionVolume.port_3)
    annotation (Line(points={{0,-59},{0,-70},{0,-70}}, color={0,127,255}));
  connect(teeJunctionVolume.port_2, lineToPump.port_a) annotation (Line(points={
          {10,-80},{29.5,-80},{29.5,-80}}, color={0,127,255}));
  connect(lineToPump.port_b, toPump.ports[1]) annotation (Line(points={{43.5,-80},
          {56,-80},{70,-80}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    experiment(
      StopTime=1000,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Esdirk45a"),
    __Dymola_experimentSetupOutput);
end Pressurizer_Test;
