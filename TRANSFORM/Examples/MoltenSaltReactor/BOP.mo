within TRANSFORM.Examples.MoltenSaltReactor;
model BOP

  package Medium_PCL = TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_pT (
  extraPropertiesNames={"Tritium"},
  C_nominal={1e6}) "Primary coolant loop medium";

package Medium_BOP = Modelica.Media.Water.StandardWater;

  parameter Integer toggleStaticHead = 0 "=1 to turn on, =0 to turn off";

  HeatExchangers.GenericDistributed_HX           SHX(
    redeclare package Medium_shell = Medium_PCL,
    redeclare package Material_tubeWall = Media.Solids.AlloyN,
    nParallel=2*3,
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        nV=10,
        nR=3,
        D_o_shell=data_SHX.D_shell_inner,
        nTubes=data_SHX.nTubes,
        length_shell=data_SHX.length_tube,
        dimension_tube=data_SHX.D_tube_inner,
        length_tube=data_SHX.length_tube,
        th_wall=data_SHX.th_tube),
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.FlowAcrossTubeBundles_Grimison
        (
        CF=fill(0.44, SHX.shell.heatTransfer.nHT),
        D=data_SHX.D_tube_outer,
        S_T=data_SHX.pitch_tube,
        S_L=data_SHX.pitch_tube),
    p_a_start_shell=data_SHX.p_inlet_shell,
    T_a_start_shell=data_SHX.T_inlet_shell,
    T_b_start_shell=data_SHX.T_outlet_shell,
    m_flow_a_start_shell=2*3*data_SHX.m_flow_shell,
    p_a_start_tube=data_SHX.p_inlet_tube,
    T_a_start_tube=data_SHX.T_inlet_tube,
    T_b_start_tube=data_SHX.T_outlet_tube,
    m_flow_a_start_tube=2*3*data_SHX.m_flow_tube,
    redeclare package Medium_tube = Medium_BOP)   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,0})));

  Fluid.BoundaryConditions.Boundary_pT boundary2(
    nPorts=1,
    redeclare package Medium = Medium_PCL,
    p=data_SHX.p_outlet_shell,
    T=data_SHX.T_outlet_shell)
                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-114,-28})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary3(
    nPorts=1,
    redeclare package Medium = Medium_PCL,
    m_flow=2*3*data_SHX.m_flow_shell,
    T=data_SHX.T_inlet_shell) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,32})));
  Data.data_SHX data_SHX
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Fluid.Volumes.MixingVolume steamMixer(
    nPorts_a=1,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1),
    redeclare package Medium = Medium_BOP,
    nPorts_b=1)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Data.data_BOP data_BOP
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Fluid.Volumes.IdealCondenser condenser1(
    V_liquid_start=5,
    redeclare package Medium = Medium_BOP,
    p=data_BOP.p_outlet_LP)
    annotation (Placement(transformation(extent={{20,-22},{40,-2}})));
  Fluid.Machines.Pump_SimpleMassFlow pump_BOP(m_flow_nominal=2*3*data_SHX.m_flow_tube,
      redeclare package Medium = Medium_BOP)
    annotation (Placement(transformation(extent={{-30,-50},{-50,-30}})));
  Fluid.Volumes.MixingVolume FWH(
    use_HeatPort=true,
    nPorts_b=1,
    nPorts_a=1,
    redeclare package Medium = Medium_BOP)
    annotation (Placement(transformation(extent={{0,-50},{-20,-30}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature FWH_returnTemp(T=
        data_SHX.T_inlet_tube)
    annotation (Placement(transformation(extent={{-36,-70},{-16,-50}})));
  Fluid.Machines.SteamTurbineStodola steamTurbine_HP(
    redeclare package Medium = Medium_BOP,
    p_a_start=data_SHX.p_outlet_tube,
    T_a_start=data_SHX.T_outlet_tube,
    m_flow_start=2*3*data_SHX.m_flow_shell,
    p_b_start=data_BOP.p_outlet_HP)
    annotation (Placement(transformation(extent={{-34,14},{-14,34}})));
  Fluid.Volumes.MixingVolume HP_vol(
    nPorts_a=1,
    p_start=steamTurbine_HP.p_b_start,
    T_start=steamTurbine_HP.T_b_start,
    redeclare package Medium = Medium_BOP,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.LumpedVolume.GenericVolume (V=1),
    nPorts_b=1)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Fluid.Machines.SteamTurbineStodola steamTurbine_LP(
    redeclare package Medium = Medium_BOP,
    T_a_start=data_SHX.T_outlet_tube,
    m_flow_start=2*3*data_SHX.m_flow_shell,
    p_a_start=steamTurbine_HP.p_b_start,
    p_b_start=data_BOP.p_outlet_LP)
    annotation (Placement(transformation(extent={{-2,14},{18,34}})));
  Electrical.Sources.FrequencySource boundary6(f=60)
    annotation (Placement(transformation(extent={{100,14},{80,34}})));
  Electrical.PowerConverters.Generator generator1
    annotation (Placement(transformation(extent={{54,14},{74,34}})));
  Modelica.Mechanics.Rotational.Sensors.PowerSensor powerSensor1
    annotation (Placement(transformation(extent={{28,34},{48,14}})));
equation
  connect(boundary2.ports[1], SHX.port_b_shell) annotation (Line(points={{-104,
          -28},{-84.6,-28},{-84.6,-10}},
                                    color={0,127,255}));
  connect(boundary3.ports[1], SHX.port_a_shell) annotation (Line(points={{-100,32},
          {-84.6,32},{-84.6,10}}, color={0,127,255}));
  connect(steamMixer.port_a[1], SHX.port_b_tube)
    annotation (Line(points={{-56,30},{-80,30},{-80,10}}, color={0,127,255}));
  connect(FWH_returnTemp.port, FWH.heatPort)
    annotation (Line(points={{-16,-60},{-10,-60},{-10,-46}}, color={191,0,0}));
  connect(FWH.port_b[1], pump_BOP.port_a)
    annotation (Line(points={{-16,-40},{-30,-40}}, color={0,127,255}));
  connect(condenser1.port_b, FWH.port_a[1])
    annotation (Line(points={{30,-20},{30,-40},{-4,-40}}, color={0,127,255}));
  connect(powerSensor1.flange_b, generator1.shaft)
    annotation (Line(points={{48,24},{54,24}}, color={0,0,0}));
  connect(generator1.port, boundary6.port)
    annotation (Line(points={{74,24},{80,24}}, color={255,0,0}));
  connect(steamTurbine_LP.shaft_b, powerSensor1.flange_a)
    annotation (Line(points={{18,24},{28,24}}, color={0,0,0}));
  connect(steamMixer.port_b[1], steamTurbine_HP.portHP)
    annotation (Line(points={{-44,30},{-34,30}}, color={0,127,255}));
  connect(HP_vol.port_a[1], steamTurbine_HP.portLP)
    annotation (Line(points={{-16,0},{-16,14},{-17,14}}, color={0,127,255}));
  connect(HP_vol.port_b[1], steamTurbine_LP.portHP)
    annotation (Line(points={{-4,0},{-4,30},{-2,30}}, color={0,127,255}));
  connect(steamTurbine_HP.shaft_b, steamTurbine_LP.shaft_a)
    annotation (Line(points={{-14,24},{-2,24}}, color={0,0,0}));
  connect(pump_BOP.port_b, SHX.port_a_tube) annotation (Line(points={{-50,-40},
          {-80,-40},{-80,-10}}, color={0,127,255}));
  connect(steamTurbine_LP.portLP, condenser1.port_a) annotation (Line(points={{
          15,14},{14,14},{14,6},{23,6},{23,-5}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=5000, __Dymola_NumberOfIntervals=5000));
end BOP;
