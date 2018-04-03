within TRANSFORM.Examples.MoltenSaltReactor.Examples;
model Check_PHX

package Material = TRANSFORM.Media.Solids.AlloyN;

SI.SpecificHeatCapacity cp = Material.specificHeatCapacityCp_T(sum(uAdT_lm.Ts_h)/2);

  HeatExchangers.UAdT_lm uAdT_lm(Ts_h={data.T_inlet_tube,data.T_outlet_tube},
      Ts_c={data.T_inlet_shell,data.T_outlet_shell},
    Q_flow=data.m_flow_tube*cp*(uAdT_lm.Ts_h[1] - uAdT_lm.Ts_h[2]),
    U_input=
        TRANSFORM.Units.Conversions.Functions.CoefficientOfHeatTransfer_W_m2K.from_btuhrft2f(
        700),
    calcType="U",
    surfaceArea_input=TRANSFORM.Units.Conversions.Functions.Area_m2.from_feet2(
        4024))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Data.data_PHX data
    annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));
  Fluid.BoundaryConditions.Boundary_pT boundary3(
    nPorts=1,
    p=data_PHX.p_outlet_shell,
    T=data_PHX.T_outlet_shell,
    redeclare package Medium = Medium_PCL)
                             annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={120,40})));
  HeatExchangers.GenericDistributed_HXold STHX(
    nParallel=3,
    redeclare package Medium_shell = Medium_PCL,
    redeclare package Medium_tube = Medium_PFL,
    redeclare package Material_tubeWall = Media.Solids.AlloyN,
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
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.Nus_SinglePhase_2Region,
    p_a_start_shell=data_PHX.p_inlet_shell,
    T_a_start_shell=data_PHX.T_inlet_shell,
    T_b_start_shell=data_PHX.T_outlet_shell,
    m_flow_a_start_shell=3*data_PHX.m_flow_shell,
    p_a_start_tube=data_PHX.p_inlet_tube,
    T_a_start_tube=data_PHX.T_inlet_tube,
    T_b_start_tube=data_PHX.T_outlet_tube,
    m_flow_a_start_tube=3*data_PHX.m_flow_tube,
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D.FlowAcrossTubeBundles_Grimison
        (
        D=data_PHX.D_tube_outer,
        S_T=data_PHX.pitch_tube,
        S_L=data_PHX.pitch_tube)) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={80,0})));

  Fluid.BoundaryConditions.MassFlowSource_T boundary2(
    nPorts=1,
    m_flow=3*data_PHX.m_flow_shell,
    T=data_PHX.T_inlet_shell,
    redeclare package Medium = Medium_PCL)
                              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={120,-20})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Check_PHX;
