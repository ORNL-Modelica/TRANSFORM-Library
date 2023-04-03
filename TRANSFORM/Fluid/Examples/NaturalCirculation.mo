within TRANSFORM.Fluid.Examples;
model NaturalCirculation
  extends TRANSFORM.Icons.Example;
  Pipes.GenericPipe_MultiTransferSurface
                    riser(
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        dimension=0.01,
        length=10,
        angle=1.5707963267949,
        nV=10),
    use_HeatTransfer=true,
    p_a_start=1*9.81*1000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_b_start=100000,
    redeclare model HeatTransfer =
        ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,0})));
  Pipes.GenericPipe_MultiTransferSurface
                    downcomer(
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        dimension=0.01,
        length=10,
        nV=10,
        angle=-1.5707963267949),
    use_HeatTransfer=true,
    exposeState_a=false,
    exposeState_b=true,
    p_b_start=1*9.81*1000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_a_start=100000,
    redeclare model HeatTransfer =
        ClosureRelations.HeatTransfer.Models.DistributedPipe_1D_MultiTransferSurface.Nus_SinglePhase_2Region)
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={20,0})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature_multi boundary(nPorts=
       riser.nV, use_port=true)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature_multi boundary1(
      nPorts=downcomer.nV, use_port=true)
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Blocks.Sources.Ramp rampUpWallTemp[riser.nV](
    each startTime=100,
    each offset=293.15,
    each height=80,
    each duration=10)
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Volumes.ExpansionTank expansionTank(
    V0=0.01,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    level_start=0.1,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    A=0.01) annotation (Placement(transformation(extent={{-10,16},{10,36}})));
  FittingsAndResistances.SpecifiedResistance resistance2(R=1/1e6) annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={0,-20})));
  TRANSFORM.Utilities.Visualizers.Outputs.SpatialPlot2 temperaturePlot(
    x1=riser.summary.xpos_norm,
    y1={riser.mediums[i].T for i in 1:riser.geometry.nV},
    x2=Modelica.Math.Vectors.reverse(downcomer.summary.xpos_norm),
    y2={downcomer.mediums[i].T for i in 1:downcomer.geometry.nV},
    minY1=273.15,
    maxY1=473.15) annotation (Placement(transformation(extent={{6,-80},{56,-36}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(
    printResult=false,
    n=3,
    x={riser.mediums[2].T,downcomer.mediums[2].T,riser.port_a.m_flow})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Utilities.Visualizers.DynamicGraph massFlowRatePlot(
    y_var=riser.port_a.m_flow,
    y_name="Mass Flow Rate",
    Unit="kg/s",
    t_end=1000,
    y_max=0.025,
    y_min=-0.025)
    annotation (Placement(transformation(extent={{-56,-80},{-4,-32}})));
  Modelica.Blocks.Math.Add add[riser.nV]
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.Ramp rampDownWallTemp[riser.nV](
    each startTime=400,
    height=-rampUpWallTemp.height,
    each duration=10)
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Modelica.Blocks.Sources.Ramp rampUpWallTemp1[downcomer.nV](
    each offset=293.15,
    each height=80,
    each duration=10,
    each startTime=500)
    annotation (Placement(transformation(extent={{120,10},{100,30}})));
  Modelica.Blocks.Math.Add add1[downcomer.nV]
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.Ramp rampDownWallTemp1[downcomer.nV](
    each duration=10,
    height=-rampUpWallTemp1.height,
    each startTime=800)
    annotation (Placement(transformation(extent={{120,-30},{100,-10}})));
  TRANSFORM.Utilities.Visualizers.Outputs.Bar tankLevel(
    hideConnector=true,
    input_Value=expansionTank.level,
    min=0.1,
    max=0.13) annotation (Placement(transformation(extent={{10,40},{30,60}})));
equation
  connect(downcomer.port_b, resistance2.port_a)
    annotation (Line(points={{20,-10},{20,-20},{7,-20}}, color={0,127,255}));
  connect(resistance2.port_b, riser.port_a) annotation (Line(points={{-7,-20},{-20,
          -20},{-20,-10}}, color={0,127,255}));
  connect(riser.port_b, expansionTank.port_a)
    annotation (Line(points={{-20,10},{-20,20},{-7,20}}, color={0,127,255}));
  connect(downcomer.port_a, expansionTank.port_b) annotation (Line(points={{20,10},
          {20,20},{7,20}},                 color={0,127,255}));
  connect(rampDownWallTemp.y, add.u2) annotation (Line(points={{-99,-20},{-92,
          -20},{-92,-6},{-82,-6}}, color={0,0,127}));
  connect(rampUpWallTemp.y, add.u1) annotation (Line(points={{-99,20},{-92,20},
          {-92,6},{-82,6}}, color={0,0,127}));
  connect(add.y, boundary.T_ext)
    annotation (Line(points={{-59,0},{-54,0},{-54,0}}, color={0,0,127}));
  connect(boundary1.T_ext, add1.y)
    annotation (Line(points={{54,0},{59,0}}, color={0,0,127}));
  connect(add1.u1, rampUpWallTemp1.y)
    annotation (Line(points={{82,6},{90,6},{90,20},{99,20}}, color={0,0,127}));
  connect(rampDownWallTemp1.y, add1.u2) annotation (Line(points={{99,-20},{90,
          -20},{90,-6},{82,-6}}, color={0,0,127}));
  connect(boundary.port, riser.heatPorts[:, 1])
    annotation (Line(points={{-40,0},{-25,0}}, color={191,0,0}));
  connect(boundary1.port, downcomer.heatPorts[:, 1])
    annotation (Line(points={{40,0},{25,0}}, color={191,0,0}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=1000,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Esdirk45a"));
end NaturalCirculation;
