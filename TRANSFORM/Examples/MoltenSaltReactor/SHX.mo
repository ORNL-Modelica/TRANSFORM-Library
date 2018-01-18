within TRANSFORM.Examples.MoltenSaltReactor;
model SHX

  package Medium_PFL = TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_12Th_05U_pT (
  extraPropertiesNames=data_traceSubstances.extraPropertiesNames,
  C_nominal=data_traceSubstances.C_nominal) "Primary fuel loop medium";
//   package Medium_PFL = TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_12Th_05U_pT (
//   extraPropertiesNames={"PreGroup_1","PreGroup_2","PreGroup_3","PreGroup_4","PreGroup_5","PreGroup_6"},
//   C_nominal=fill(1e14,6)) "Primary fuel loop medium";

  package Medium_PCL = TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_pT(extraPropertiesNames={"bob"},C_nominal={1e6}) "Primary coolant loop medium";

  parameter Integer toggleStaticHead = 0 "=1 to turn on, =0 to turn off";


  Fluid.BoundaryConditions.Boundary_pT boundary3(
    nPorts=1,
    p=data_PHX.p_outlet_tube,
    T=data_PHX.T_outlet_tube,
    redeclare package Medium = Medium_PFL)
                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-30})));
  HeatExchangers.GenericDistributed_HX PHX(
    redeclare package Medium_shell = Medium_PCL,
    redeclare package Medium_tube = Medium_PFL,
    redeclare package Material_tubeWall = Media.Solids.AlloyN,
    p_a_start_shell=data_PHX.p_inlet_shell,
    T_a_start_shell=data_PHX.T_inlet_shell,
    T_b_start_shell=data_PHX.T_outlet_shell,
    p_a_start_tube=data_PHX.p_inlet_tube,
    T_a_start_tube=data_PHX.T_inlet_tube,
    T_b_start_tube=data_PHX.T_outlet_tube,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX
        (
        D_o_shell=data_PHX.D_shell_inner,
        nV=10,
        nTubes=data_PHX.nTubes,
        nR=3,
        length_shell=data_PHX.length_tube,
        th_wall=data_PHX.th_tube,
        dimension_tube=data_PHX.D_tube_inner,
        length_tube=data_PHX.length_tube),
    nParallel=2*3,
    m_flow_a_start_shell=2*3*data_PHX.m_flow_shell,
    m_flow_a_start_tube=2*3*data_PHX.m_flow_tube,
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.FlowAcrossTubeBundles_Grimison
        (
        D=data_PHX.D_tube_outer,
        S_T=data_PHX.pitch_tube,
        S_L=data_PHX.pitch_tube,
        CF=fill(0.44, PHX.shell.heatTransfer.nHT)))
                                           annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-2,2})));

  Fluid.BoundaryConditions.MassFlowSource_T boundary2(
    nPorts=1,
    m_flow=2*3*data_PHX.m_flow_tube,
    T=data_PHX.T_inlet_tube,
    redeclare package Medium = Medium_PFL)
                              annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,30})));
  Data.data_RCTR data_RCTR
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Data.data_PHX data_PHX
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Data.data_SHX data_SHX
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Data.data_PIPING data_PIPING
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Data.data_PUMP data_PUMP
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Fluid.BoundaryConditions.Boundary_pT boundary1(
    p=data_SHX.p_outlet_tube,
    T=data_SHX.T_outlet_tube,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1)                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={170,40})));
  Fluid.BoundaryConditions.MassFlowSource_T boundary4(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=2*3*data_SHX.m_flow_tube,
    T=data_SHX.T_inlet_tube,
    nPorts=1)                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={174,-20})));
  Data.data_traceSubstances
    data_traceSubstances
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface pipeToPHX_PCL(
    showName=systemTF.showName,
    redeclare package Medium = Medium_PCL,
    m_flow_a_start=2*3*data_PHX.m_flow_shell,
    p_a_start=data_PHX.p_inlet_shell + 50,
    T_a_start=data_PHX.T_inlet_shell,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        nV=10,
        dimension=data_PIPING.D_PCL,
        length=data_PIPING.length_SHXToPHX,
        dheight=toggleStaticHead*data_PIPING.height_SHXToPHX),
    nParallel=3)                                                annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,-20})));
  Fluid.Volumes.ExpansionTank pumpBowl(
    level_start=data_RCTR.level_pumpbowlnominal,
    showName=systemTF.showName,
    redeclare package Medium = Medium_PCL,
    h_start=pumpBowl.Medium.specificEnthalpy_pT(pumpBowl.p_start, data_PHX.T_outlet_shell),
    A=3*data_RCTR.crossArea_pumpbowl)
    annotation (Placement(transformation(extent={{56,36},{76,56}})));

  Fluid.Machines.Pump_SimpleMassFlow pump_PFL(redeclare package Medium =
        Medium_PCL, m_flow_nominal=2*3*data_PHX.m_flow_shell)
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface pipeFromPHX_PCL(
    nParallel=3,
    showName=systemTF.showName,
    redeclare package Medium = Medium_PCL,
    p_a_start=data_PHX.p_inlet_shell - 50,
    T_a_start=data_PHX.T_outlet_shell,
    m_flow_a_start=2*3*data_PHX.m_flow_shell,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        nV=10,
        dimension=data_PIPING.D_PCL,
        length=data_PIPING.length_PHXsToPump,
        dheight=toggleStaticHead*data_PIPING.height_PHXsToPump))
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,40})));
  Fluid.Pipes.GenericPipe_MultiTransferSurface pipeToSHX_PCL(
    nParallel=3,
    showName=systemTF.showName,
    redeclare package Medium = Medium_PCL,
    T_a_start=data_PHX.T_outlet_shell,
    m_flow_a_start=2*3*data_PHX.m_flow_shell,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        nV=10,
        dimension=data_PIPING.D_PCL,
        length=data_PIPING.length_pumpToSHX,
        dheight=toggleStaticHead*data_PIPING.height_pumpToSHX),
    p_a_start=data_PHX.p_inlet_shell + 300) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={120,40})));
  inner Fluid.SystemTF systemTF(showName=false)
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  HeatExchangers.GenericDistributed_HX PHX1(
    redeclare package Medium_shell = Medium_PCL,
    redeclare package Material_tubeWall = Media.Solids.AlloyN,
    nParallel=2*3,
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    redeclare package Medium_tube = Modelica.Media.Water.StandardWater,
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
        CF=fill(0.44, PHX.shell.heatTransfer.nHT),
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
    m_flow_a_start_tube=2*3*data_SHX.m_flow_tube)
                                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={140,0})));

equation
  connect(boundary3.ports[1], PHX.port_b_tube)
    annotation (Line(points={{-60,-30},{-2,-30},{-2,-8}}, color={0,127,255}));
  connect(boundary2.ports[1], PHX.port_a_tube)
    annotation (Line(points={{-60,30},{-2,30},{-2,12}}, color={0,127,255}));
  connect(pipeToPHX_PCL.port_b, PHX.port_a_shell)
    annotation (Line(points={{40,-20},{2.6,-20},{2.6,-8}}, color={0,127,255}));
  connect(pump_PFL.port_a, pumpBowl.port_b)
    annotation (Line(points={{80,40},{72,40}}, color={0,127,255}));
  connect(pumpBowl.port_a, pipeFromPHX_PCL.port_b)
    annotation (Line(points={{60,40},{40,40}}, color={0,127,255}));
  connect(pipeFromPHX_PCL.port_a, PHX.port_b_shell)
    annotation (Line(points={{20,40},{2.6,40},{2.6,12}}, color={0,127,255}));
  connect(pump_PFL.port_b, pipeToSHX_PCL.port_a)
    annotation (Line(points={{100,40},{110,40}}, color={0,127,255}));
  connect(pipeToPHX_PCL.port_a, PHX1.port_b_shell) annotation (Line(points={{60,
          -20},{135.4,-20},{135.4,-10}}, color={0,127,255}));
  connect(pipeToSHX_PCL.port_b, PHX1.port_a_shell) annotation (Line(points={{
          130,40},{136,40},{136,10},{135.4,10}}, color={0,127,255}));
  connect(boundary4.ports[1], PHX1.port_a_tube) annotation (Line(points={{164,
          -20},{140,-20},{140,-10}}, color={0,127,255}));
  connect(boundary1.ports[1], PHX1.port_b_tube)
    annotation (Line(points={{160,40},{140,40},{140,10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},
            {140,120}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-140},{140,120}})),
    experiment(StopTime=5000, __Dymola_NumberOfIntervals=5000));
end SHX;
