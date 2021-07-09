within TRANSFORM.HeatExchangers.Examples;
model SteamWater_HCSG
  "Evaporation of a subcooled inlet water stream to superheated steam (helical coil tube side) and subcooled water (shell side)"
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  import      Modelica.Units.SI;
  import TRANSFORM.Units.Conversions.Functions;
  package Medium = Modelica.Media.Water.StandardWater;
  parameter SI.Temperature tube_inlet_T = Medium.temperature_ph(tube_outlet.p,tube_inlet.h);
  parameter SI.Temperature tube_outlet_T = Medium.temperature_ph(tube_outlet.p,tube_outlet.h);
  Modelica.Fluid.Sources.Boundary_ph tube_outlet(
    p(displayUnit="MPa") = 5800000,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1,
    h=2.95363e6)
    annotation (Placement(transformation(extent={{51,-5},{41,5}})));
  Modelica.Fluid.Sources.MassFlowSource_h tube_inlet(
    m_flow=502.8,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1,
    h=962463,
    use_m_flow_in=false)
              annotation (Placement(transformation(extent={{-52,-6},{-40,6}})));
  Modelica.Fluid.Sources.Boundary_pT shell_outlet(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p(displayUnit="MPa") = 15712238,
    T=556.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-51,15},{-41,25}})));
  Modelica.Fluid.Sources.MassFlowSource_T shell_inlet(
    m_flow=4712,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1,
    T=594.15) annotation (Placement(transformation(extent={{52,14},{40,26}})));
  TRANSFORM.HeatExchangers.GenericDistributed_HX STHX(
    nParallel=8,
    redeclare package Medium_shell = Modelica.Media.Water.StandardWater,
    redeclare package Medium_tube = Modelica.Media.Water.StandardWater,
    p_a_start_shell=shell_outlet.p + 1000,
    p_b_start_shell=shell_outlet.p,
    T_a_start_shell=shell_inlet.T,
    T_b_start_shell=shell_outlet.T,
    m_flow_a_start_shell=shell_inlet.m_flow,
    p_b_start_tube=tube_outlet.p,
    m_flow_a_start_tube=tube_inlet.m_flow,
    p_a_start_tube=tube_outlet.p + 1e5,
    redeclare package Material_tubeWall =
        TRANSFORM.Media.Solids.Inconel690,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX (
        D_o_shell=1.64,
        D_i_shell=0.61,
        nTubes=750,
        th_wall=0.00211,
        dimension_tube=0.01324,
        length_tube=32,
        dheight_shell=STHX.geometry.length_shell,
        length_shell=7.9,
        nV=20,
        nR=3),
    use_Ts_start_tube=false,
    h_a_start_tube=962463,
    h_b_start_tube=2.95363e6,
    redeclare model HeatTransfer_tube =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Alphas_TwoPhase_3Region,
    redeclare model HeatTransfer_shell =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region
        (Nus_turb={{
            TRANSFORM.HeatAndMassTransfer.ClosureRelations.HeatTransfer.Functions.SinglePhase.ExternalFlow.Nu_Grimison_FlowAcrossTubeBanks(
            STHX.shell.heatTransfer.Res[i],
            STHX.shell.heatTransfer.Prs[i],
            STHX.geometry.dimension_tube + 2*STHX.geometry.th_wall,
            1.25*(STHX.geometry.dimension_tube + 2*STHX.geometry.th_wall),
            1.25*(STHX.geometry.dimension_tube + 2*STHX.geometry.th_wall)) for
            j in 1:STHX.shell.heatTransfer.nSurfaces} for i in 1:STHX.geometry.nV}))
    annotation (Placement(transformation(extent={{-23,-20},{19,20}})));
  UserInteraction.Outputs.SpatialPlot2 spatialPlot2_1(
    y1={STHX.tube.mediums[i].T for i in 1:STHX.geometry.nV},
    y2={STHX.shell.mediums[i].T for i in 1:STHX.geometry.nV},
    x1=STHX.tube.summary.xpos_norm,
    x2=if STHX.counterCurrent == true then Modelica.Math.Vectors.reverse(STHX.shell.summary.xpos_norm)
         else STHX.shell.summary.xpos_norm,
    minY1=min({tube_inlet_T,shell_inlet.T,tube_outlet_T,shell_outlet.T}),
    maxY1=max({tube_inlet_T,shell_inlet.T,tube_outlet_T,shell_outlet.T}),
    minY2=min({tube_inlet_T,shell_inlet.T,tube_outlet_T,shell_outlet.T}),
    maxY2=max({tube_inlet_T,shell_inlet.T,tube_outlet_T,shell_outlet.T}))
    annotation (Placement(transformation(extent={{-96,-92},{-46,-48}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests
                                    unitTests(n=4, x={STHX.tube.mediums[2].p,
        STHX.shell.mediums[2].p,STHX.tube.mediums[2].h,STHX.shell.mediums[2].h})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(shell_inlet.ports[1], STHX.port_a_shell) annotation (Line(points={{40,20},
          {30,20},{30,9},{26,9},{20,9},{20,9.2},{19,9.2}},
                                          color={0,127,255}));
  connect(tube_inlet.ports[1], STHX.port_a_tube)
    annotation (Line(points={{-40,0},{-23,0}},          color={0,127,255}));
  connect(tube_outlet.ports[1], STHX.port_b_tube)
    annotation (Line(points={{41,0},{19,0}},         color={0,127,255}));
  connect(shell_outlet.ports[1], STHX.port_b_shell) annotation (Line(points={{-41,
          20},{-31,20},{-31,9},{-27,9},{-23,9},{-23,9.2}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=1000, __Dymola_NumberOfIntervals=1000),
    __Dymola_experimentSetupOutput);
end SteamWater_HCSG;
