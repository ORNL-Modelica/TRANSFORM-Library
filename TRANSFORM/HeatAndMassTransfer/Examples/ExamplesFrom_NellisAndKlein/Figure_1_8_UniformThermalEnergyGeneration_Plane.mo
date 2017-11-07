within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein;
model Figure_1_8_UniformThermalEnergyGeneration_Plane
  "Uniform thermaly energy generation in a plane wall (Figure 1-8) | pg. 28"
  import TRANSFORM;
  extends Icons.Example;
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(
    n=12,
    x_reference=TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degC({
        80,82,84,84,82,78,72,64,54,42,28,20}),
    x=cat(
        1,
        {T_H.T},
        wall1.materials.T,
        {T_C.T}),
    name="Figure_1_8_UniformThermalEnergyGeneration")
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_H(T=
        353.15)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_C(T=
        293.15)
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Blocks.Sources.Constant L(each k=0.01) "Length of plane wall"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  DiscritizedModels.Conduction_1D wall(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    exposeState_a1=false,
    redeclare model Geometry =
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_1D (
        nX=nNodes_1.k,
        length_x=L.y,
        length_y=1,
        length_z=1),
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_1_d_7990_cp_500)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=10)
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  UserInteraction.Outputs.SpatialPlot TemperaturePlot(
    minY=20,
    maxY=180,
    maxX=1,
    x=TRANSFORM.Units.Conversions.Functions.Distance_m.to_cm(cat(
        1,
        {0},
        wall.geometry.xs,
        {L.k})),
    y=TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(cat(
        1,
        {T_H.T},
        wall.materials.T,
        {T_C.T}))) "X - Axial Location (cm) | T - Temperature (°C)"
    annotation (Placement(transformation(extent={{64,-14},{98,18}})));

  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_H1(T=
        353.15)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_C1(T=
        293.15)
    annotation (Placement(transformation(extent={{60,-40},{40,-20}})));
  DiscritizedModels.Conduction_1D wall1(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    exposeState_a1=false,
    redeclare model Geometry =
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_1D (
        nX=nNodes_1.k,
        length_x=L.y,
        length_y=1,
        length_z=1),
    exposeState_b1=false,
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_1_d_7990_cp_500,
    redeclare model InternalHeatModel =
        DiscritizedModels.BaseClasses.Dimensions_1.VolumetricHeatGeneration (
          q_ppp=2e6))
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));

  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_H2(T=
        353.15)
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_C2(T=
        293.15)
    annotation (Placement(transformation(extent={{60,-70},{40,-50}})));
  DiscritizedModels.Conduction_1D wall2(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    exposeState_a1=false,
    redeclare model Geometry =
      TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_1D (
        nX=nNodes_1.k,
        length_x=L.y,
        length_y=1,
        length_z=1),
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_1_d_7990_cp_500,
    redeclare model InternalHeatModel =
        DiscritizedModels.BaseClasses.Dimensions_1.VolumetricHeatGeneration (
          q_ppp=1e7))
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

  UserInteraction.Outputs.SpatialPlot TemperaturePlot1(
    minY=20,
    maxY=180,
    maxX=1,
    x=TRANSFORM.Units.Conversions.Functions.Distance_m.to_cm(cat(
        1,
        {0},
        wall1.geometry.xs,
        {L.k})),
    y=TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(cat(
        1,
        {T_H1.T},
        wall1.materials.T,
        {T_C1.T}))) "X - Axial Location (cm) | T - Temperature (°C)"
    annotation (Placement(transformation(extent={{64,-46},{98,-14}})));
  UserInteraction.Outputs.SpatialPlot TemperaturePlot2(
    minY=20,
    maxY=180,
    maxX=1,
    x=TRANSFORM.Units.Conversions.Functions.Distance_m.to_cm(cat(
        1,
        {0},
        wall2.geometry.xs,
        {L.k})),
    y=TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(cat(
        1,
        {T_H2.T},
        wall2.materials.T,
        {T_C2.T}))) "X - Axial Location (cm) | T - Temperature (°C)"
    annotation (Placement(transformation(extent={{64,-76},{98,-44}})));

  Modelica.Blocks.Sources.RealExpression deltaT_max(y=(L.y^2*sum(0)/
        nNodes_1.k/(4*1))) "Sanity check for order of magnitude expected"
    annotation (Placement(transformation(extent={{-70,-5},{-90,15}})));
  Modelica.Blocks.Sources.RealExpression deltaT_max1(y=(L.y^2*sum(wall1.internalHeatModel.q_ppps)
        /nNodes_1.k/(4*1))) "Sanity check for order of magnitude expected"
    annotation (Placement(transformation(extent={{-70,-35},{-90,-15}})));
  Modelica.Blocks.Sources.RealExpression deltaT_max2(y=(L.y^2*sum(wall2.internalHeatModel.q_ppps)
        /nNodes_1.k/(4*1))) "Sanity check for order of magnitude expected"
    annotation (Placement(transformation(extent={{-70,-65},{-90,-45}})));
  Utilities.Visualizers.displayReal display(use_port=true)
    annotation (Placement(transformation(extent={{-90,-15},{-70,5}})));
  Utilities.Visualizers.displayReal display1(use_port=true)
    annotation (Placement(transformation(extent={{-90,-45},{-70,-25}})));
  Utilities.Visualizers.displayReal display2(use_port=true)
    annotation (Placement(transformation(extent={{-90,-75},{-70,-55}})));
equation

  connect(deltaT_max.y, display.u) annotation (Line(points={{-91,5},{-96,5},{-96,
          -5},{-91.5,-5}}, color={0,0,127}));
  connect(deltaT_max1.y, display1.u) annotation (Line(points={{-91,-25},{-96,-25},
          {-96,-35},{-91.5,-35}}, color={0,0,127}));
  connect(deltaT_max2.y, display2.u) annotation (Line(points={{-91,-55},{-96,-55},
          {-96,-65},{-91.5,-65}}, color={0,0,127}));
  connect(wall.port_b1, T_C.port)
    annotation (Line(points={{10,0},{40,0}},        color={191,0,0}));
  connect(wall1.port_b1, T_C1.port) annotation (Line(points={{10,-30},{25,
          -30},{40,-30}}, color={191,0,0}));
  connect(wall2.port_b1, T_C2.port) annotation (Line(points={{10,-60},{25,
          -60},{40,-60}}, color={191,0,0}));
  connect(T_H.port, wall.port_a1)
    annotation (Line(points={{-40,0},{-25,0},{-10,0}}, color={191,0,0}));
  connect(T_H1.port, wall1.port_a1) annotation (Line(points={{-40,-30},{-25,
          -30},{-10,-30}}, color={191,0,0}));
  connect(T_H2.port, wall2.port_a1) annotation (Line(points={{-40,-60},{-25,
          -60},{-10,-60}}, color={191,0,0}));
  annotation (experiment(__Dymola_NumberOfIntervals=100));
end Figure_1_8_UniformThermalEnergyGeneration_Plane;
