within TRANSFORM.Examples.SupercriticalCO2.Examples;
model SCO2Loop

  extends TRANSFORM.Icons.Example;

  package Medium = ExternalMedia.Examples.CO2CoolProp(p_default=8e6);  //Requires VS2012 compiler option
  package Medium_salt = TRANSFORM.Media.Fluids.KClMgCl2.LinearKClMgCl2_67_33_pT;

  Data.Data_Basic data
    annotation (Placement(transformation(extent={{110,80},{130,100}})));

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
        nV=20,
        CF_th_wall=0.5),
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
    nPorts=1,
    use_m_flow_in=false)
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Fluid.Sensors.MassFlowRate massFlowRate(redeclare package Medium = Medium,
      precision=1,
    showName=systemTF.showName)
                   annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={86,-30})));
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
    m_flow_a_start=data.m_flow_salt_300kw,
    showName=systemTF.showName,
    T_a_start=419.15,
    T_b_start=373.15)                      annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,-50})));

  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow sink_AHX(Q_flow=-0.5*
        data.Q_nominal, use_port=true,
    showName=systemTF.showName)        annotation (Placement(transformation(
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
    m_flow_a_start=data.m_flow_salt_300kw,
    showName=systemTF.showName,
    T_a_start=373.15,
    T_b_start=301.15)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-80}})));

  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow sink_WHX(Q_flow=-0.5*
        data.Q_nominal, use_port=true,
    showName=systemTF.showName)        annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-50,-94})));
  Fluid.Sensors.PressureTemperature sensor_pT(
    redeclare package Medium = Medium,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    showName=systemTF.showName,
    precision=2,
    precision2=1)
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Fluid.Sensors.PressureTemperature sensor_pT1(
    redeclare package Medium = Medium,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    showName=systemTF.showName,
    precision=2,
    precision2=1)
    annotation (Placement(transformation(extent={{30,-70},{50,-90}})));
  Modelica.Blocks.Sources.RealExpression setpoint_T_WHX_outlet(y=data.T_cold_PCL)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-86,-106})));
  HeatExchangers.GenericDistributed_HX RHX_3(
    redeclare package Medium_tube = Medium,
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    m_flow_a_start_tube=data.m_flow_co2_300kw,
    redeclare package Medium_shell = Medium,
    p_a_start_shell=data.p_nominal_PCL,
    m_flow_a_start_shell=data.m_flow_co2_300kw,
    p_a_start_tube=data.p_nominal_PCL + 1e5,
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    redeclare package Material_tubeWall = Media.Solids.Inconel690,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        nR=3,
        D_o_shell=0.1683 - 2*0.02195,
        length_shell=2,
        dimension_tube=0.01715 - 2*0.00231,
        th_wall=0.00231,
        nTubes=15,
        length_tube=2*RHX_3.geometry.length_shell,
        nV=20),
    T_a_start_shell=998.15,
    T_b_start_shell=774.35,
    T_a_start_tube=534.75,
    T_b_start_tube=765.85) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-10,50})));

  Fluid.Sensors.PressureTemperature sensor_pT2(
    redeclare package Medium = Medium,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    showName=systemTF.showName,
    precision=2,
    precision2=1)
    annotation (Placement(transformation(extent={{-90,10},{-70,-10}})));
  Fluid.Sensors.PressureTemperature sensor_pT3(
    redeclare package Medium = Medium,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    showName=systemTF.showName,
    precision=2,
    precision2=1)
    annotation (Placement(transformation(extent={{-70,-70},{-90,-90}})));
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
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    showName=systemTF.showName)
    annotation (Placement(transformation(extent={{-40,40},{-60,60}})));

  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow sink_AHX1(use_port=true, showName=
       systemTF.showName)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-50,74})));
  Fluid.Machines.Pump_SimpleMassFlow pump_SimpleMassFlow(redeclare package
      Medium = Medium, m_flow_nominal=data.m_flow_co2_300kw,
    use_input=false)
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Fluid.FittingsAndResistances.TeeJunctionVolume teeJunctionVolume(redeclare
      package Medium = Medium, V=0.01)
    annotation (Placement(transformation(extent={{-20,-64},{-8,-76}})));
  Fluid.Sensors.PressureTemperature sensor_pT4(
    redeclare package Medium = Medium,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    showName=systemTF.showName,
    precision=2,
    precision2=1)
    annotation (Placement(transformation(extent={{-20,-70},{-40,-90}})));
  Fluid.Sensors.PressureTemperature sensor_pT5(
    redeclare package Medium = Medium,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    showName=systemTF.showName,
    precision=2,
    precision2=1)
    annotation (Placement(transformation(extent={{-6,32},{14,12}})));
  Fluid.FittingsAndResistances.SpecifiedResistance resistance(redeclare package
      Medium = Medium, R=1e6,
    showName=systemTF.showName)
                              annotation (Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={-14,-84})));
  Fluid.BoundaryConditions.Boundary_pT tank_CO2(
    redeclare package Medium = Medium,
    p(displayUnit="MPa") = data.p_nominal_PCL,
    nPorts=1,
    T=data.T_cold_PCL,
    showName=systemTF.showName)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-14,-106})));
  Controls.LimPID PID_AuxHeat(
    k_s=1/data.T_out_pcx,
    k_m=1/data.T_out_pcx,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5e4,
    yb=2e5) annotation (Placement(transformation(extent={{-72,84},{-60,96}})));
  Modelica.Blocks.Sources.RealExpression setpoint_T_PCHX_outlet(y=data.T_out_pcx)
    annotation (Placement(transformation(extent={{-92,84},{-80,96}})));
  HeatExchangers.GenericDistributed_HX RHX_2(
    redeclare package Medium_tube = Medium,
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    m_flow_a_start_tube=data.m_flow_co2_300kw,
    redeclare package Medium_shell = Medium,
    p_a_start_shell=data.p_nominal_PCL,
    m_flow_a_start_shell=data.m_flow_co2_300kw,
    p_a_start_tube=data.p_nominal_PCL + 1e5,
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    redeclare package Material_tubeWall = Media.Solids.Inconel690,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        nR=3,
        D_o_shell=0.1683 - 2*0.02195,
        length_shell=2,
        dimension_tube=0.01715 - 2*0.00231,
        th_wall=0.00231,
        nTubes=15,
        length_tube=2*RHX_3.geometry.length_shell,
        nV=20),
    T_a_start_shell=774.35,
    T_b_start_shell=562.95,
    T_a_start_tube=361.25,
    T_b_start_tube=534.75) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={20,50})));

  HeatExchangers.GenericDistributed_HX RHX_1(
    redeclare package Medium_tube = Medium,
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    m_flow_a_start_tube=data.m_flow_co2_300kw,
    redeclare package Medium_shell = Medium,
    p_a_start_shell=data.p_nominal_PCL,
    m_flow_a_start_shell=data.m_flow_co2_300kw,
    T_a_start_tube=data.T_cold_PCL,
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    redeclare package Material_tubeWall = Media.Solids.Inconel690,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        nR=3,
        D_o_shell=0.1683 - 2*0.02195,
        length_shell=2,
        dimension_tube=0.01715 - 2*0.00231,
        th_wall=0.00231,
        nTubes=15,
        length_tube=2*RHX_3.geometry.length_shell,
        nV=20),
    T_a_start_shell=562.95,
    T_b_start_shell=419.15,
    p_a_start_tube=data.p_nominal_PCL + 1e5,
    T_b_start_tube=361.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,50})));

  Fluid.Sensors.PressureTemperature sensor_pT6(
    redeclare package Medium = Medium,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    showName=systemTF.showName,
    precision=2,
    precision2=1)
    annotation (Placement(transformation(extent={{26,32},{46,12}})));
  Fluid.Sensors.PressureTemperature sensor_pT7(
    redeclare package Medium = Medium,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    showName=systemTF.showName,
    precision=2,
    precision2=1)
    annotation (Placement(transformation(extent={{56,32},{76,12}})));
  Fluid.Sensors.PressureTemperature sensor_pT8(
    redeclare package Medium = Medium,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    showName=systemTF.showName,
    precision=2,
    precision2=1)
    annotation (Placement(transformation(extent={{-6,62},{14,82}})));
  Fluid.Sensors.PressureTemperature sensor_pT9(
    redeclare package Medium = Medium,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    showName=systemTF.showName,
    precision=2,
    precision2=1)
    annotation (Placement(transformation(extent={{26,62},{46,82}})));
  Fluid.Sensors.PressureTemperature sensor_pT10(
    redeclare package Medium = Medium,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    showName=systemTF.showName,
    precision=2,
    precision2=1)
    annotation (Placement(transformation(extent={{56,62},{76,82}})));
  Controls.LimPID PID_AHX(
    k_s=1/data.T_out_pcx,
    k_m=1/data.T_out_pcx,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5e4)
    annotation (Placement(transformation(extent={{-134,-56},{-122,-44}})));
  Modelica.Blocks.Sources.RealExpression setpoint_T_AHX_outlet(y=100 + 273.15)
    annotation (Placement(transformation(extent={{-152,-56},{-140,-44}})));
  Controls.LimPID PID_WHX(
    k_s=1/data.T_out_pcx,
    k_m=1/data.T_out_pcx,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=5e4)
    annotation (Placement(transformation(extent={{-72,-112},{-60,-100}})));
  inner Fluid.SystemTF systemTF(
    showName=false,
    showColors=true,
    val_min=data.T_cold_PCL,
    val_max=data.T_hot_PCL)
    annotation (Placement(transformation(extent={{130,80},{150,100}})));
  Fluid.Sensors.PressureTemperature sensor_pT11(
    redeclare package Medium = Medium,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    showName=systemTF.showName,
    precision=2,
    precision2=1)
    annotation (Placement(transformation(extent={{-40,62},{-20,82}})));
  Fluid.Sensors.PressureTemperature sensor_pT12(
    redeclare package Medium = Medium,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    showName=systemTF.showName,
    precision=2,
    precision2=1)
    annotation (Placement(transformation(extent={{-40,32},{-20,12}})));
  Fluid.Sensors.PressureTemperature sensor_pT13(
    redeclare package Medium = Medium,
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    showName=systemTF.showName,
    precision=2,
    precision2=1)
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Fluid.Sensors.PressureTemperature sensor_pT14(
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    showName=systemTF.showName,
    precision=2,
    precision2=1,
    redeclare package Medium = Medium_salt)
    annotation (Placement(transformation(extent={{-116,50},{-96,70}})));
  Fluid.Sensors.PressureTemperature sensor_pT15(
    redeclare function iconUnit =
        Units.Conversions.Functions.Pressure_Pa.to_MPa,
    showName=systemTF.showName,
    precision=2,
    precision2=1,
    redeclare package Medium = Medium_salt)
    annotation (Placement(transformation(extent={{-116,10},{-96,30}})));
equation
  connect(sensor_pT2.T, PID_AuxHeat.u_m) annotation (Line(
      points={{-73.8,2.2},{-66,2.2},{-66,82.8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(source_salt.ports[1], PCHX.port_a_shell) annotation (Line(points={{
          -120,10},{-84.6,10},{-84.6,20}}, color={0,127,255}));
  connect(PCHX.port_a_tube, AuxHeating.port_b)
    annotation (Line(points={{-80,40},{-80,50},{-60,50}}, color={0,127,255}));
  connect(sensor_pT.port, PCHX.port_a_tube)
    annotation (Line(points={{-80,50},{-80,40}}, color={0,127,255}));
  connect(AuxHeating.port_a, RHX_3.port_b_tube)
    annotation (Line(points={{-40,50},{-20,50}}, color={0,127,255}));
  connect(sink_AHX1.port, AuxHeating.heatPorts[1, 1])
    annotation (Line(points={{-50,64},{-50,55}}, color={191,0,0}));
  connect(sink_AHX.port, AHX.heatPorts[1, 1])
    annotation (Line(points={{-100,-50},{-85,-50}}, color={191,0,0}));
  connect(sink_WHX.port, WHX.heatPorts[1, 1])
    annotation (Line(points={{-50,-84},{-50,-75}}, color={191,0,0}));
  connect(WHX.port_a, AHX.port_b) annotation (Line(points={{-60,-70},{-80,-70},
          {-80,-60}}, color={0,127,255}));
  connect(sensor_pT2.port, PCHX.port_b_tube)
    annotation (Line(points={{-80,10},{-80,20}}, color={0,127,255}));
  connect(sensor_pT3.port, AHX.port_b)
    annotation (Line(points={{-80,-70},{-80,-60}}, color={0,127,255}));
  connect(tank_CO2.ports[1], resistance.port_b) annotation (Line(points={{-14,-100},
          {-14,-86.8}},                  color={0,127,255}));
  connect(setpoint_T_PCHX_outlet.y, PID_AuxHeat.u_s)
    annotation (Line(points={{-79.4,90},{-73.2,90}}, color={0,0,127}));
  connect(PID_AuxHeat.y, sink_AHX1.Q_flow_ext)
    annotation (Line(points={{-59.4,90},{-50,90},{-50,78}}, color={0,0,127}));
  connect(WHX.port_a, sensor_pT3.port)
    annotation (Line(points={{-60,-70},{-80,-70}}, color={0,127,255}));
  connect(pump_SimpleMassFlow.port_b, sensor_pT1.port)
    annotation (Line(points={{20,-70},{40,-70}}, color={0,127,255}));
  connect(RHX_3.port_b_shell, RHX_2.port_a_shell) annotation (Line(points={{0,45.4},
          {6,45.4},{6,45.4},{10,45.4}}, color={0,127,255}));
  connect(RHX_3.port_a_tube, RHX_2.port_b_tube)
    annotation (Line(points={{0,50},{10,50}}, color={0,127,255}));
  connect(RHX_2.port_b_shell, RHX_1.port_a_shell) annotation (Line(points={{30,45.4},
          {36,45.4},{36,45.4},{40,45.4}}, color={0,127,255}));
  connect(RHX_2.port_a_tube, RHX_1.port_b_tube)
    annotation (Line(points={{30,50},{40,50}}, color={0,127,255}));
  connect(sensor_pT5.port, RHX_3.port_b_shell)
    annotation (Line(points={{4,32},{4,45.4},{0,45.4}}, color={0,127,255}));
  connect(sensor_pT6.port, RHX_2.port_b_shell)
    annotation (Line(points={{36,32},{36,45.4},{30,45.4}}, color={0,127,255}));
  connect(sensor_pT9.port, RHX_1.port_b_tube)
    annotation (Line(points={{36,62},{36,50},{40,50}}, color={0,127,255}));
  connect(sensor_pT8.port, RHX_2.port_b_tube)
    annotation (Line(points={{4,62},{4,50},{10,50}}, color={0,127,255}));
  connect(sensor_pT7.port, RHX_1.port_b_shell)
    annotation (Line(points={{66,32},{66,45.4},{60,45.4}}, color={0,127,255}));
  connect(sensor_pT10.port, RHX_1.port_a_tube)
    annotation (Line(points={{66,62},{66,50},{60,50}}, color={0,127,255}));
  connect(AHX.port_a, RHX_1.port_b_shell) annotation (Line(points={{-80,-40},{-80,
          -30},{76,-30},{76,45.4},{60,45.4}}, color={0,127,255}));
  connect(PID_AHX.y, sink_AHX.Q_flow_ext)
    annotation (Line(points={{-121.4,-50},{-114,-50}}, color={0,0,127}));
  connect(sensor_pT3.T, PID_AHX.u_m) annotation (Line(
      points={{-86.2,-77.8},{-128,-77.8},{-128,-57.2}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(setpoint_T_AHX_outlet.y, PID_AHX.u_s)
    annotation (Line(points={{-139.4,-50},{-135.2,-50}}, color={0,0,127}));
  connect(PID_WHX.y, sink_WHX.Q_flow_ext) annotation (Line(points={{-59.4,-106},
          {-50,-106},{-50,-98}}, color={0,0,127}));
  connect(setpoint_T_WHX_outlet.y, PID_WHX.u_s)
    annotation (Line(points={{-79.4,-106},{-73.2,-106}}, color={0,0,127}));
  connect(sensor_pT4.T, PID_WHX.u_m) annotation (Line(
      points={{-36.2,-77.8},{-40,-77.8},{-40,-116},{-66,-116},{-66,-113.2}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(sensor_pT11.port, RHX_3.port_b_tube)
    annotation (Line(points={{-30,62},{-30,50},{-20,50}}, color={0,127,255}));
  connect(sensor_pT12.port, RHX_3.port_a_shell) annotation (Line(points={{-30,32},
          {-30,45.4},{-20,45.4}}, color={0,127,255}));
  connect(PCHX.port_b_tube, RHX_3.port_a_shell) annotation (Line(points={{-80,20},
          {-80,10},{-40,10},{-40,45.4},{-20,45.4}}, color={0,127,255}));
  connect(AHX.port_a, sensor_pT13.port)
    annotation (Line(points={{-80,-40},{-80,-30}}, color={0,127,255}));
  connect(teeJunctionVolume.port_2, pump_SimpleMassFlow.port_a)
    annotation (Line(points={{-8,-70},{0,-70}}, color={0,127,255}));
  connect(teeJunctionVolume.port_3, resistance.port_a)
    annotation (Line(points={{-14,-76},{-14,-81.2}}, color={0,127,255}));
  connect(WHX.port_b, teeJunctionVolume.port_1)
    annotation (Line(points={{-40,-70},{-20,-70}}, color={0,127,255}));
  connect(sensor_pT4.port, WHX.port_b)
    annotation (Line(points={{-30,-70},{-40,-70}}, color={0,127,255}));
  connect(sink_salt.ports[1], PCHX.port_b_shell) annotation (Line(points={{-120,
          50},{-84.6,50},{-84.6,40}}, color={0,127,255}));
  connect(sensor_pT14.port, PCHX.port_b_shell) annotation (Line(points={{-106,50},
          {-84.6,50},{-84.6,40}}, color={0,127,255}));
  connect(sensor_pT15.port, PCHX.port_a_shell) annotation (Line(points={{-106,10},
          {-84.6,10},{-84.6,20}}, color={0,127,255}));
  connect(pump_SimpleMassFlow.port_b, massFlowRate.port_a)
    annotation (Line(points={{20,-70},{86,-70},{86,-40}}, color={0,127,255}));
  connect(massFlowRate.port_b, RHX_1.port_a_tube)
    annotation (Line(points={{86,-20},{86,50},{60,50}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-120},{100,
            100}})),
    experiment(
      StopTime=2000,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Esdirk45a"));
end SCO2Loop;
