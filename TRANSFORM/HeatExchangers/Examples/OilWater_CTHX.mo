within TRANSFORM.HeatExchangers.Examples;
model OilWater_CTHX
  "Example of an oil and water concentric tube heat exchanger"
  import TRANSFORM;

  extends TRANSFORM.Icons.Example;

   parameter SI.TemperatureDifference DT_lm2 = 43.2 "Log mean temperature difference";
   parameter SI.CoefficientOfHeatTransfer U2_shell = 38.1 "Overall heat transfer coefficient - shell side";

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
    annotation (Placement(transformation(extent={{51,-5},{41,5}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T shell_inlet(
    m_flow=0.1,
    T(displayUnit="degC") = 373.15,
    redeclare package Medium =
        Media.Fluids.Incompressible.EngineOilUnused,
    nPorts=1)
    annotation (Placement(transformation(extent={{51,15},{39,27}})));

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
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.HeatExchanger.ConcentricTubeHX
        (
        D_o_shell=0.045,
        length_tube=65.9,
        dimension_tube=0.025,
        th_wall=0.0001,
        nV=10,
        nR=3),
    p_a_start_tube=tube_outlet.p + 100,
    T_a_start_tube=tube_inlet.T,
    T_b_start_tube=tube_outlet.T,
    p_a_start_shell=shell_outlet.p + 100,
    energyDynamics={Modelica.Fluid.Types.Dynamics.SteadyStateInitial,Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
        Modelica.Fluid.Types.Dynamics.SteadyStateInitial},
    redeclare model HeatTransfer_tube =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region,
    redeclare model HeatTransfer_shell =
        TRANSFORM.Fluid.ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
    annotation (Placement(transformation(extent={{-21,-20},{21,20}})));

   SI.TemperatureDifference DT_lm "Log mean temperature difference";
   SI.ThermalConductance UA "Overall heat transfer conductance";

   SI.CoefficientOfHeatTransfer U_shell "Overall heat transfer coefficient - shell side";
   SI.CoefficientOfHeatTransfer U_tube "Overall heat transfer coefficient - tube side";

   SI.CoefficientOfHeatTransfer alphaAvg_shell "Average shell side heat transfer coefficient";
   SI.ThermalResistance R_shell;

   SI.CoefficientOfHeatTransfer alphaAvg_tube;
   SI.ThermalResistance R_tube;

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

  alphaAvg_shell =sum(STHX.shell.heatTransfer.alphas)/STHX.geometry.nV;
  R_shell =1/(alphaAvg_shell*sum(STHX.shell.geometry.surfaceAreas));

  alphaAvg_tube =sum(STHX.tube.heatTransfer.alphas)/STHX.geometry.nV;
  R_tube =1/(alphaAvg_tube*sum(STHX.tube.geometry.surfaceAreas));

  DT_lm = TRANSFORM.HeatExchangers.Utilities.Functions.LMTD(
        T_hi=STHX.shell.mediums[1].T,
        T_ho=STHX.shell.mediums[STHX.geometry.nV].T,
        T_ci=STHX.tube.mediums[1].T,
        T_co=STHX.tube.mediums[STHX.geometry.nV].T,
        counterCurrent=STHX.counterCurrent);

  UA = TRANSFORM.HeatExchangers.Utilities.Functions.UA(
        n=3,
        isSeries={true,true,true},
        R=[R_tube; 1.25412e-6; R_shell]);

  U_shell =UA/sum(STHX.shell.geometry.surfaceAreas);
  U_tube =UA/sum(STHX.tube.geometry.surfaceAreas);

  connect(shell_inlet.ports[1], STHX.port_a_shell) annotation (Line(points={{39,21},
          {21,21},{21,9.2}},        color={0,127,255}));
  connect(shell_outlet.ports[1], STHX.port_b_shell) annotation (Line(points={{-41,20},
          {-21,20},{-21,9.2}},         color={0,127,255}));
  connect(tube_inlet.ports[1], STHX.port_a_tube) annotation (Line(points={{-39,0},
          {-21,0}},             color={0,127,255}));
  connect(tube_outlet.ports[1], STHX.port_b_tube)
    annotation (Line(points={{41,0},{21,0}},             color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=1000, __Dymola_NumberOfIntervals=1000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Example 11.1 (pp. 680-682).</p>
<p>A counterflow, concentric tube heat exchanger with oil and water taken from Example 11.1 (pp. 680-682) of Fundamentals of Heat and Mass Transfer by Incropera and DeWitt.</p>
</html>"));
end OilWater_CTHX;
