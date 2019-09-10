within TRANSFORM.HeatExchangers.Examples;
model OilWater_PCHX
  "Example of an oil and water printed circuit heat exchanger"
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T tube_inlet(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    m_flow=0.2,
    T(displayUnit="degC") = 303.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{-51,-6},{-39,6}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT tube_outlet(
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    p(displayUnit="bar") = 100000,
    T(displayUnit="degC") = 313.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{49,-5},{39,5}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T shell_inlet(
    m_flow=0.1,
    T(displayUnit="degC") = 373.15,
    redeclare package Medium =
        Media.Fluids.Incompressible.EngineOilUnused,
    nPorts=1)
    annotation (Placement(transformation(extent={{51,14},{39,26}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT shell_outlet(
    p(displayUnit="bar") = 100000,
    T(displayUnit="degC") = 333.15,
    redeclare package Medium =
        Media.Fluids.Incompressible.EngineOilUnused,
    nPorts=1)
    annotation (Placement(transformation(extent={{-51,15},{-41,25}})));
  TRANSFORM.HeatExchangers.GenericDistributed_HX STHX(
    p_b_start_shell=shell_outlet.p,
    T_a_start_shell=shell_inlet.T,
    T_b_start_shell=shell_outlet.T,
    p_b_start_tube=tube_outlet.p,
    counterCurrent=true,
    m_flow_a_start_tube=tube_inlet.m_flow,
    m_flow_a_start_shell=shell_inlet.m_flow,
    redeclare package Medium_tube = Modelica.Media.Water.StandardWater,
    redeclare package Medium_shell =
        Media.Fluids.Incompressible.EngineOilUnused,
    redeclare package Material_tubeWall = Media.Solids.SS316,
    p_a_start_tube=tube_outlet.p + 100,
    T_a_start_tube=tube_inlet.T,
    T_b_start_tube=tube_outlet.T,
    p_a_start_shell=shell_outlet.p + 100,
    nParallel=30,
    energyDynamics={Modelica.Fluid.Types.Dynamics.SteadyStateInitial,Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
        Modelica.Fluid.Types.Dynamics.SteadyStateInitial},
    redeclare model HeatTransfer_shell =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus
        (use_LambdaState=false, lambda0=0.625),
    redeclare model HeatTransfer_tube =
        Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus
        (use_LambdaState=false, lambda0=0.138),
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.PrintedCircuitHX
        (
        length=0.131,
        th_tube=0.00218,
        nV=10,
        nT=60,
        nR=3))
    annotation (Placement(transformation(extent={{-21,-20},{21,20}})));
  UserInteraction.Outputs.SpatialPlot2 spatialPlot2_1(
    y1={STHX.tube.mediums[i].T for i in 1:STHX.geometry.nV},
    y2={STHX.shell.mediums[i].T for i in 1:STHX.geometry.nV},
    x1=STHX.tube.summary.xpos_norm,
    minY1=min({tube_inlet.T,shell_inlet.T,tube_outlet.T,shell_outlet.T}),
    maxY1=max({tube_inlet.T,shell_inlet.T,tube_outlet.T,shell_outlet.T}),
    minY2=min({tube_inlet.T,shell_inlet.T,tube_outlet.T,shell_outlet.T}),
    maxY2=max({tube_inlet.T,shell_inlet.T,tube_outlet.T,shell_outlet.T}),
    x2=if STHX.counterCurrent == true then Modelica.Math.Vectors.reverse(STHX.shell.summary.xpos_norm)
         else STHX.shell.summary.xpos_norm)
    annotation (Placement(transformation(extent={{-96,-92},{-46,-48}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests
                                    unitTests(n=4, x={STHX.tube.mediums[2].p,
        STHX.shell.mediums[2].p,STHX.tube.mediums[2].h,STHX.shell.mediums[2].h})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(shell_inlet.ports[1], STHX.port_a_shell) annotation (Line(points={{39,20},
          {21,20},{21,9.2}},              color={0,127,255}));
  connect(shell_outlet.ports[1], STHX.port_b_shell) annotation (Line(points={{-41,20},
          {-21,20},{-21,9.2}},                color={0,127,255}));
  connect(tube_inlet.ports[1], STHX.port_a_tube)
    annotation (Line(points={{-39,0},{-21,0}},          color={0,127,255}));
  connect(tube_outlet.ports[1], STHX.port_b_tube)
    annotation (Line(points={{39,0},{21,0}},         color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=1000, __Dymola_NumberOfIntervals=1000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Example 11.1 (pp. 680-682).</p>
<p>A counterflow, compact, plate-type heat exchanger with oil and water taken from Example 11.2 (pp. 683-686) of Fundamentals of Heat and Mass Transfer by Incropera and DeWitt.</p>
</html>"));
end OilWater_PCHX;
