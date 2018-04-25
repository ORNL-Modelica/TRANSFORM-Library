within TRANSFORM.Examples.SupercriticalCO2;
model v2

  package Medium = ExternalMedia.Examples.CO2CoolProp(p_default=8e6);  //Requires VS2012 compiler option
  package Medium_salt = TRANSFORM.Media.Fluids.KClMgCl2.LinearKClMgCl2_67_33_pT;

  Data.Data_Basic data
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  Fluid.BoundaryConditions.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    m_flow=data.m_flow_co2_300kw,
    T=data.T_in_pcx,
    nPorts=1)
    annotation (Placement(transformation(extent={{54,-60},{34,-40}})));
  Fluid.BoundaryConditions.Boundary_pT boundary1(
    redeclare package Medium = Medium,
    p(displayUnit="MPa") = data.p_nominal_PCL,
    T=data.T_out_pcx,
    nPorts=1) annotation (Placement(transformation(extent={{98,42},{78,62}})));
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
        nV=10,
        nR=3),
    p_a_start_shell=100000)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,0})));
  Fluid.BoundaryConditions.Boundary_pT sink_salt(
    T=data.T_cold_salt,
    redeclare package Medium = Medium_salt,
    p(displayUnit="MPa") = 100000,
    nPorts=1) annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Fluid.BoundaryConditions.MassFlowSource_T source_salt(
    nPorts=1,
    m_flow=data.m_flow_salt_300kw,
    T=data.T_hot_salt,
    redeclare package Medium = Medium_salt)
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Fluid.Sensors.Pressure pressure1(
    redeclare package Medium = Medium,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_bar,
    precision=1)
    annotation (Placement(transformation(extent={{-110,-50},{-90,-70}})));
  Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium = Medium,
      precision=1)
    annotation (Placement(transformation(extent={{-40,-60},{-60,-40}})));
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
    m_flow_a_start=data.m_flow_salt_300kw)
    annotation (Placement(transformation(extent={{-60,42},{-40,62}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow sink_AHX(Q_flow=-0.5*
        data.Q_nominal, use_port=true) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-50,74})));
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
    annotation (Placement(transformation(extent={{-20,42},{0,62}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow sink_WHX(Q_flow=-0.5*
        data.Q_nominal, use_port=true) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-10,74})));
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
    annotation (Placement(transformation(extent={{10,60},{30,80}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=-0.5*sum(PCHX.tube.heatTransfer.Q_flows)
        *PCHX.nParallel)
    annotation (Placement(transformation(extent={{-32,76},{-44,88}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=-0.5*sum(PCHX.tube.heatTransfer.Q_flows)
        *PCHX.nParallel)
    annotation (Placement(transformation(extent={{-26,76},{-14,88}})));
equation
  connect(source_salt.ports[1], PCHX.port_a_shell) annotation (Line(points={{
          -100,40},{-84.6,40},{-84.6,10}}, color={0,127,255}));
  connect(sink_salt.ports[1], PCHX.port_b_shell) annotation (Line(points={{-100,
          -30},{-84.6,-30},{-84.6,-10}}, color={0,127,255}));
  connect(pressure1.port, PCHX.port_a_tube) annotation (Line(points={{-100,-50},
          {-80,-50},{-80,-10}}, color={0,127,255}));
  connect(boundary.ports[1], massFlowRate.port_a)
    annotation (Line(points={{34,-50},{-40,-50}}, color={0,127,255}));
  connect(massFlowRate.port_b, PCHX.port_a_tube) annotation (Line(points={{-60,
          -50},{-80,-50},{-80,-10}}, color={0,127,255}));
  connect(AHX.port_a, PCHX.port_b_tube)
    annotation (Line(points={{-60,52},{-80,52},{-80,10}}, color={0,127,255}));
  connect(sink_AHX.port, AHX.heatPorts[1, 1])
    annotation (Line(points={{-50,64},{-50,57}}, color={191,0,0}));
  connect(boundary1.ports[1], WHX.port_b) annotation (Line(points={{78,52},{40,
          52},{40,52},{0,52}}, color={0,127,255}));
  connect(WHX.port_a, AHX.port_b)
    annotation (Line(points={{-20,52},{-40,52}}, color={0,127,255}));
  connect(sink_WHX.port, WHX.heatPorts[1, 1])
    annotation (Line(points={{-10,64},{-10,57}}, color={191,0,0}));
  connect(sensor_pT.port, PCHX.port_b_tube)
    annotation (Line(points={{-80,60},{-80,10}}, color={0,127,255}));
  connect(sensor_pT1.port, WHX.port_b)
    annotation (Line(points={{20,60},{20,52},{0,52}}, color={0,127,255}));
  connect(realExpression.y, sink_AHX.Q_flow_ext)
    annotation (Line(points={{-44.6,82},{-50,82},{-50,78}}, color={0,0,127}));
  connect(realExpression1.y, sink_WHX.Q_flow_ext)
    annotation (Line(points={{-13.4,82},{-10,82},{-10,78}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100));
end v2;
