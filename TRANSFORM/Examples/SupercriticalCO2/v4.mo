within TRANSFORM.Examples.SupercriticalCO2;
model v4

  package Medium = ExternalMedia.Examples.CO2CoolProp(p_default=8e6);  //Requires VS2012 compiler option
  package Medium_salt = TRANSFORM.Media.Fluids.KClMgCl2.LinearKClMgCl2_67_33_pT;

  Data.Data_Basic data
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  HeatExchangers.GenericDistributed_HX PCHX(
    redeclare package Medium_shell = Medium_salt,
    redeclare package Medium_tube = Medium,
    redeclare package Material_tubeWall = Media.Solids.SS316,
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,

    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,

    T_a_start_shell=data.T_hot_salt,
    T_b_start_shell=data.T_cold_salt,
    m_flow_a_start_shell=data.m_flow_salt_300kw,
    p_a_start_tube=data.p_nominal_PCL,
    m_flow_a_start_tube=data.m_flow_co2_300kw,
    T_a_start_tube=data.T_in_pcx,
    T_b_start_tube=data.T_out_pcx,
    nParallel=data.nT_300,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.PrintedCircuitHX
        (
        length=data.length_pcx,
        th_tube=data.r_pcx*2,
        nR=3,
        nV=2),
    p_a_start_shell=100000)
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,30})));
  Fluid.BoundaryConditions.Boundary_pT sink_salt(
    T=data.T_cold_salt,
    redeclare package Medium = Medium_salt,
    p(displayUnit="MPa") = 100000,
    nPorts=1) annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Fluid.BoundaryConditions.MassFlowSource_T source_salt(
    m_flow=data.m_flow_salt_300kw,
    T=data.T_hot_salt,
    redeclare package Medium = Medium_salt,
    nPorts=1)
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium = Medium,
      precision=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={40,-10})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface AHX(
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data.d_inner_ahx, length=data.length_ahx),
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,

    nParallel=data.nTubes_ahx,
    p_a_start=data.p_nominal_PCL,
    T_a_start=data.T_hot_PCL,
    m_flow_a_start=data.m_flow_salt_300kw) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,-50})));
  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow sink_AHX(Q_flow=-0.5*
        data.Q_nominal, use_port=true) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-110,-50})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface WHX(
    redeclare package Medium = Medium,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data.d_inner_ahx, length=data.length_ahx),
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,

    nParallel=data.nTubes_ahx,
    p_a_start=data.p_nominal_PCL,
    T_a_start=data.T_hot_PCL,
    m_flow_a_start=data.m_flow_salt_300kw)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-80}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow sink_WHX(Q_flow=-0.5*
        data.Q_nominal, use_port=true) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-50,-94})));
  Fluid.Sensors.PressureTemperature sensor_pT(
    redeclare package Medium = Medium,
    precision=1,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa)
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Fluid.Sensors.PressureTemperature sensor_pT1(
    redeclare package Medium = Medium,
    precision=1,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa)
    annotation (Placement(transformation(extent={{30,-80},{50,-100}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=-0.5*sum(PCHX.tube.heatTransfer.Q_flows)
        *PCHX.nParallel)
    annotation (Placement(transformation(extent={{-132,-56},{-120,-44}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=-0.5*sum(PCHX.tube.heatTransfer.Q_flows)
        *PCHX.nParallel) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-60,-110})));
  HeatExchangers.GenericDistributed_HX RHX(
    redeclare package Medium_tube = Medium,
    redeclare package Material_tubeWall = Media.Solids.SS316,
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,

    m_flow_a_start_tube=data.m_flow_co2_300kw,
    redeclare package Medium_shell = Medium,
    p_a_start_shell=data.p_nominal_PCL,
    m_flow_a_start_shell=data.m_flow_co2_300kw,
    T_a_start_shell=data.T_hot_PCL,
    p_a_start_tube=data.p_nominal_PCL + 1e5,
    T_a_start_tube=data.T_cold_PCL,
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,

    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        nR=3,
        length_tube=RHX.geometry.length_shell,
        dimension_tube=0.01715 - 2*0.0032,
        th_wall=0.0032,
        nTubes=30,
        D_o_shell=0.1683 - 2*0.02195,
        length_shell=10,
        nV=2)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-10,50})));
  Fluid.Sensors.PressureTemperature sensor_pT2(
    redeclare package Medium = Medium,
    precision=1,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa)
    annotation (Placement(transformation(extent={{-90,0},{-70,-20}})));
  Fluid.Sensors.PressureTemperature sensor_pT3(
    redeclare package Medium = Medium,
    precision=1,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa)
    annotation (Placement(transformation(extent={{-110,-70},{-90,-90}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface AuxHeating(
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    p_a_start=data.p_nominal_PCL,
    m_flow_a_start=data.m_flow_salt_300kw,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (dimension=data.d_inner_pipe),
    T_a_start=data.T_in_pcx,
    redeclare model HeatTransfer =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
    annotation (Placement(transformation(extent={{-40,40},{-60,60}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature sink_AHX1(use_port=
        false, T=data.T_in_pcx) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-50,74})));
  Fluid.Machines.Pump_SimpleMassFlow pump_SimpleMassFlow(redeclare package
      Medium = Medium, m_flow_nominal=data.m_flow_co2_300kw)
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Fluid.FittingsAndResistances.TeeJunctionVolume teeJunctionVolume(redeclare
      package Medium = Medium, V=0.01)
    annotation (Placement(transformation(extent={{-30,-64},{-18,-76}})));
  Fluid.Sensors.PressureTemperature sensor_pT4(
    redeclare package Medium = Medium,
    precision=1,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa)
    annotation (Placement(transformation(extent={{-18,-62},{2,-42}})));
  Fluid.Sensors.PressureTemperature sensor_pT5(
    redeclare package Medium = Medium,
    precision=1,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa)
    annotation (Placement(transformation(extent={{-10,0},{10,-20}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance(redeclare package
      Medium = Medium, R=1e6) annotation (Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={-24,-84})));
  Fluid.BoundaryConditions.Boundary_pT tank_CO2(
    redeclare package Medium = Medium,
    p(displayUnit="MPa") = data.p_nominal_PCL,
    nPorts=1,
    T=data.T_cold_PCL)
    annotation (Placement(transformation(extent={{-4,-116},{-16,-104}})));
equation
  connect(source_salt.ports[1], PCHX.port_a_shell) annotation (Line(points={{
          -120,10},{-84.6,10},{-84.6,20}}, color={0,127,255}));
  connect(sink_salt.ports[1], PCHX.port_b_shell) annotation (Line(points={{-120,
          50},{-84.6,50},{-84.6,40}}, color={0,127,255}));
  connect(PCHX.port_a_tube, AuxHeating.port_b)
    annotation (Line(points={{-80,40},{-80,50},{-60,50}}, color={0,127,255}));
  connect(sensor_pT.port, PCHX.port_a_tube)
    annotation (Line(points={{-80,60},{-80,40}}, color={0,127,255}));
  connect(AuxHeating.port_a, RHX.port_b_tube)
    annotation (Line(points={{-40,50},{-20,50}}, color={0,127,255}));
  connect(sink_AHX1.port, AuxHeating.heatPorts[1, 1])
    annotation (Line(points={{-50,64},{-50,55}}, color={191,0,0}));
  connect(PCHX.port_b_tube, RHX.port_a_shell) annotation (Line(points={{-80,20},
          {-80,10},{-30,10},{-30,45.4},{-20,45.4}}, color={0,127,255}));
  connect(realExpression.y, sink_AHX.Q_flow_ext)
    annotation (Line(points={{-119.4,-50},{-114,-50}}, color={0,0,127}));
  connect(sink_AHX.port, AHX.heatPorts[1, 1])
    annotation (Line(points={{-100,-50},{-85,-50}}, color={191,0,0}));
  connect(realExpression1.y, sink_WHX.Q_flow_ext) annotation (Line(points={{
          -53.4,-110},{-50,-110},{-50,-98}}, color={0,0,127}));
  connect(sink_WHX.port, WHX.heatPorts[1, 1])
    annotation (Line(points={{-50,-84},{-50,-75}}, color={191,0,0}));
  connect(WHX.port_a, AHX.port_b) annotation (Line(points={{-60,-70},{-80,-70},
          {-80,-60}}, color={0,127,255}));
  connect(AHX.port_a, RHX.port_b_shell) annotation (Line(points={{-80,-40},{-80,
          -30},{20,-30},{20,45.4},{0,45.4}}, color={0,127,255}));
  connect(pump_SimpleMassFlow.port_b, massFlowRate.port_b)
    annotation (Line(points={{20,-70},{40,-70},{40,-20}}, color={0,127,255}));
  connect(massFlowRate.port_a, RHX.port_a_tube)
    annotation (Line(points={{40,0},{40,50},{0,50}}, color={0,127,255}));
  connect(sensor_pT1.port, massFlowRate.port_b)
    annotation (Line(points={{40,-80},{40,-20}}, color={0,127,255}));
  connect(sensor_pT2.port, PCHX.port_b_tube)
    annotation (Line(points={{-80,0},{-80,20}}, color={0,127,255}));
  connect(teeJunctionVolume.port_2, pump_SimpleMassFlow.port_a)
    annotation (Line(points={{-18,-70},{0,-70}}, color={0,127,255}));
  connect(teeJunctionVolume.port_1, WHX.port_b)
    annotation (Line(points={{-30,-70},{-40,-70}}, color={0,127,255}));
  connect(sensor_pT4.port, pump_SimpleMassFlow.port_a)
    annotation (Line(points={{-8,-62},{-8,-70},{0,-70}}, color={0,127,255}));
  connect(sensor_pT3.port, AHX.port_b) annotation (Line(points={{-100,-70},{-80,
          -70},{-80,-60}}, color={0,127,255}));
  connect(sensor_pT5.port, RHX.port_b_shell) annotation (Line(points={{0,0},{20,
          0},{20,45.4},{0,45.4}}, color={0,127,255}));
  connect(resistance.port_a, teeJunctionVolume.port_3)
    annotation (Line(points={{-24,-81.2},{-24,-76}}, color={0,127,255}));
  connect(tank_CO2.ports[1], resistance.port_b) annotation (Line(points={{-16,
          -110},{-24,-110},{-24,-86.8}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -120},{100,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-120},{100,
            100}})),
    experiment(StopTime=500, __Dymola_Algorithm="Esdirk45a"));
end v4;
