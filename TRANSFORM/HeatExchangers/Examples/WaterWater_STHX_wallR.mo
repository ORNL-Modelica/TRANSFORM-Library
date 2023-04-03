within TRANSFORM.HeatExchangers.Examples;
model WaterWater_STHX_wallR
  "Example of an water and water shell and tube exchanger"
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T tube_inlet(
    m_flow=1,
    T(displayUnit="degC") = 293.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1)
    annotation (Placement(transformation(extent={{-51,-6},{-39,6}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT tube_outlet(
    p(displayUnit="bar") = 100000,
    T(displayUnit="degC") = 333.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1)
    annotation (Placement(transformation(extent={{51,-5},{41,5}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T shell_inlet(
    T(displayUnit="degC") = 363.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=1,
    nPorts=1)
    annotation (Placement(transformation(extent={{51,14},{39,26}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT shell_outlet(
    p(displayUnit="bar") = 100000,
    T(displayUnit="degC") = 343.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1)
    annotation (Placement(transformation(extent={{-51,15},{-41,25}})));
  TRANSFORM.HeatExchangers.GenericDistributed_HX_Rwall
                                                 STHX(
    redeclare package Medium_shell = Modelica.Media.Water.StandardWater,
    redeclare package Medium_tube = Modelica.Media.Water.StandardWater,
    p_b_start_shell=shell_outlet.p,
    T_a_start_shell=shell_inlet.T,
    T_b_start_shell=shell_outlet.T,
    p_b_start_tube=tube_outlet.p,
    use_Ts_start_tube=false,
    counterCurrent=true,
    m_flow_a_start_tube=tube_inlet.m_flow,
    m_flow_a_start_shell=shell_inlet.m_flow,
    redeclare package Material_tubeWall = Media.Solids.SS316,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ShellAndTubeHX (
        nR=3,
        D_o_shell=0.3,
        length_shell=1,
        nTubes=50,
        th_wall=0.001,
        dimension_tube=0.01,
        length_tube=2,
        nV=10),
    p_a_start_tube=tube_outlet.p + 100,
    T_a_start_tube=tube_inlet.T,
    T_b_start_tube=tube_outlet.T,
    p_a_start_shell=shell_outlet.p + 100,
    energyDynamics={Modelica.Fluid.Types.Dynamics.FixedInitial,Modelica.Fluid.Types.Dynamics.FixedInitial,
        Modelica.Fluid.Types.Dynamics.FixedInitial},
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Alphas (
         alpha0=1000),
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Alphas (
         alpha0=1000))
    annotation (Placement(transformation(extent={{-21,-20},{21,20}})));
  TRANSFORM.Utilities.Visualizers.Outputs.SpatialPlot2 spatialPlot2_1(
    y1={STHX.tube.mediums[i].T for i in 1:STHX.geometry.nV},
    y2={STHX.shell.mediums[i].T for i in 1:STHX.geometry.nV},
    x1=STHX.tube.summary.xpos_norm,
    minY1=min({tube_inlet.T,shell_inlet.T,tube_outlet.T,shell_outlet.T}),
    maxY1=max({tube_inlet.T,shell_inlet.T,tube_outlet.T,shell_outlet.T}),
    minY2=min({tube_inlet.T,shell_inlet.T,tube_outlet.T,shell_outlet.T}),
    maxY2=max({tube_inlet.T,shell_inlet.T,tube_outlet.T,shell_outlet.T}),
    x2=if STHX.counterCurrent == true then Modelica.Math.Vectors.reverse(STHX.shell.summary.xpos_norm) else STHX.shell.summary.xpos_norm)
    annotation (Placement(transformation(extent={{-96,-92},{-46,-48}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests
                                    unitTests(n=4, x={STHX.tube.mediums[2].p,
        STHX.shell.mediums[2].p,STHX.tube.mediums[2].h,STHX.shell.mediums[2].h})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(shell_inlet.ports[1], STHX.port_a_shell) annotation (Line(points={{39,20},
          {21,20},{21,9.2}},                color={0,127,255}));
  connect(shell_outlet.ports[1], STHX.port_b_shell) annotation (Line(points={{-41,20},
          {-21,20},{-21,9.2}},                color={0,127,255}));
  connect(tube_inlet.ports[1], STHX.port_a_tube) annotation (Line(points={{-39,0},
          {-21,0}},                 color={0,127,255}));
  connect(tube_outlet.ports[1], STHX.port_b_tube)
    annotation (Line(points={{41,0},{21,0}},         color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(
      StopTime=1000,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Esdirk45a"),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>A counterflow shell and tube heat exchanger with the purpose of verifying the simplest application of the model, especially the effect of the value nTubes.</p>
</html>"));
end WaterWater_STHX_wallR;
