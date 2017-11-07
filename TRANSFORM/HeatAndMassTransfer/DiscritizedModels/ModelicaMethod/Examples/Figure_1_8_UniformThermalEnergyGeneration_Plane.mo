within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ModelicaMethod.Examples;
model Figure_1_8_UniformThermalEnergyGeneration_Plane
  "Uniform thermaly energy generation in a plane wall (Figure 1-8) | pg. 28"
  extends Icons.Example;
  Utilities.ErrorAnalysis.UnitTests summary_Error(
    n=12,
    x_reference=Units.Conversions.Functions.Temperature_K.from_degC({80,82,84,
        84,82,78,72,64,54,42,28,20}),
    x=cat(
        1,
        {T_H.T},
        wall1.unitCell.T,
        {T_C.T}))
    annotation (Placement(transformation(extent={{70,70},{90,90}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_H(T=353.15)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_C(T=293.15)
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Blocks.Sources.Constant L(each k=0.01) "Length of plane wall"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  DiscritizedModels.ModelicaMethod.Conduction_1D wall(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    exposeState_a1=false,
    use_Lambda=true,
    lambda=1,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_1D
        (
        nX=nNodes_1.k,
        length_x=L.y,
        length_y=1,
        length_z=1))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=10)
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  UserInteraction.Outputs.SpatialPlot TemperaturePlot(
    minY=20,
    maxY=180,
    maxX=1,
    y=Units.Conversions.Functions.Temperature_K.to_degC(cat(
        1,
        {T_H.T},
        wall.unitCell.T,
        {T_C.T})),
    x=Units.Conversions.Functions.Distance_m.to_cm(cat(
        1,
        {0},
        wall.geometry.xs,
        {L.k}))) "X - Axial Location (cm) | T - Temperature (°C)"
    annotation (Placement(transformation(extent={{64,-14},{98,18}})));

  Modelica.Blocks.Sources.Constant q_ppp[nNodes_1.k](each k=0)
    annotation (Placement(transformation(extent={{-36,6},{-28,14}})));

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_H1(
                                                             T=353.15)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_C1(
                                                             T=293.15)
    annotation (Placement(transformation(extent={{60,-40},{40,-20}})));
  DiscritizedModels.ModelicaMethod.Conduction_1D wall1(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    exposeState_a1=false,
    use_Lambda=true,
    lambda=1,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_1D
        (
        nX=nNodes_1.k,
        length_x=L.y,
        length_y=1,
        length_z=1))
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_H2(
                                                             T=353.15)
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_C2(
                                                             T=293.15)
    annotation (Placement(transformation(extent={{60,-70},{40,-50}})));
  DiscritizedModels.ModelicaMethod.Conduction_1D wall2(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    exposeState_a1=false,
    use_Lambda=true,
    lambda=1,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_1D
        (
        nX=nNodes_1.k,
        length_x=L.y,
        length_y=1,
        length_z=1))
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  UserInteraction.Outputs.SpatialPlot TemperaturePlot1(
    minY=20,
    maxY=180,
    maxX=1,
    y=Units.Conversions.Functions.Temperature_K.to_degC(cat(
        1,
        {T_H1.T},
        wall1.unitCell.T,
        {T_C1.T})),
    x=Units.Conversions.Functions.Distance_m.to_cm(cat(
        1,
        {0},
        wall1.geometry.xs,
        {L.k}))) "X - Axial Location (cm) | T - Temperature (°C)"
    annotation (Placement(transformation(extent={{64,-46},{98,-14}})));
  UserInteraction.Outputs.SpatialPlot TemperaturePlot2(
    minY=20,
    maxY=180,
    maxX=1,
    y=Units.Conversions.Functions.Temperature_K.to_degC(cat(
        1,
        {T_H2.T},
        wall2.unitCell.T,
        {T_C2.T})),
    x=Units.Conversions.Functions.Distance_m.to_cm(cat(
        1,
        {0},
        wall2.geometry.xs,
        {L.k}))) "X - Axial Location (cm) | T - Temperature (°C)"
    annotation (Placement(transformation(extent={{64,-76},{98,-44}})));

  Modelica.Blocks.Sources.RealExpression Vs[nNodes_1.k](y=wall.geometry.Vs)
    annotation (Placement(transformation(extent={{-40,14},{-24,26}})));
  Modelica.Blocks.Math.Product product[nNodes_1.k]
    annotation (Placement(transformation(extent={{-14,14},{-6,22}})));
  Modelica.Blocks.Sources.RealExpression Vs1[nNodes_1.k](y=wall.geometry.Vs)
    annotation (Placement(transformation(extent={{-38,-18},{-22,-6}})));
  Modelica.Blocks.Sources.Constant q_ppp1[nNodes_1.k](each k=2e6)
    annotation (Placement(transformation(extent={{-34,-26},{-26,-18}})));
  Modelica.Blocks.Math.Product product1[nNodes_1.k]
    annotation (Placement(transformation(extent={{-12,-18},{-4,-10}})));
  Modelica.Blocks.Sources.RealExpression Vs2[nNodes_1.k](y=wall.geometry.Vs)
    annotation (Placement(transformation(extent={{-38,-48},{-22,-36}})));
  Modelica.Blocks.Sources.Constant q_ppp2[nNodes_1.k](each k=1e7)
    annotation (Placement(transformation(extent={{-34,-56},{-26,-48}})));
  Modelica.Blocks.Math.Product product2[nNodes_1.k]
    annotation (Placement(transformation(extent={{-12,-48},{-4,-40}})));

  Modelica.Blocks.Sources.RealExpression deltaT_max(y=(L.y^2*sum(q_ppp.y)/
        nNodes_1.k/(4*1))) "Sanity check for order of magnitude expected"
    annotation (Placement(transformation(extent={{-70,-5},{-90,15}})));
  Modelica.Blocks.Sources.RealExpression deltaT_max1(y=(L.y^2*sum(q_ppp1.y)
        /nNodes_1.k/(4*1))) "Sanity check for order of magnitude expected"
    annotation (Placement(transformation(extent={{-70,-35},{-90,-15}})));
  Modelica.Blocks.Sources.RealExpression deltaT_max2(y=(L.y^2*sum(q_ppp2.y)
        /nNodes_1.k/(4*1))) "Sanity check for order of magnitude expected"
    annotation (Placement(transformation(extent={{-70,-65},{-90,-45}})));
  Utilities.Visualizers.displayReal display(use_port=true)
    annotation (Placement(transformation(extent={{-90,-15},{-70,5}})));
  Utilities.Visualizers.displayReal display1(use_port=true)
    annotation (Placement(transformation(extent={{-90,-45},{-70,-25}})));
  Utilities.Visualizers.displayReal display2(use_port=true)
    annotation (Placement(transformation(extent={{-90,-75},{-70,-55}})));
equation

  connect(q_ppp.y, product.u2) annotation (Line(points={{-27.6,10},{-22,10},{-22,
          15.6},{-14.8,15.6}}, color={0,0,127}));
  connect(Vs.y, product.u1) annotation (Line(points={{-23.2,20},{-14.8,20},
          {-14.8,20.4}}, color={0,0,127}));
  connect(Vs2.y, product2.u1) annotation (Line(points={{-21.2,-42},{-12.8,-42},
          {-12.8,-41.6}}, color={0,0,127}));
  connect(q_ppp2.y, product2.u2) annotation (Line(points={{-25.6,-52},{-20,-52},
          {-20,-46.4},{-12.8,-46.4}}, color={0,0,127}));
  connect(Vs1.y, product1.u1) annotation (Line(points={{-21.2,-12},{-12.8,-12},
          {-12.8,-11.6}}, color={0,0,127}));
  connect(q_ppp1.y, product1.u2) annotation (Line(points={{-25.6,-22},{-20,-22},
          {-20,-16.4},{-12.8,-16.4}}, color={0,0,127}));
  connect(deltaT_max.y, display.u) annotation (Line(points={{-91,5},{-96,5},{-96,
          -5},{-91.5,-5}}, color={0,0,127}));
  connect(deltaT_max1.y, display1.u) annotation (Line(points={{-91,-25},{-96,-25},
          {-96,-35},{-91.5,-35}}, color={0,0,127}));
  connect(deltaT_max2.y, display2.u) annotation (Line(points={{-91,-55},{-96,-55},
          {-96,-65},{-91.5,-65}}, color={0,0,127}));
  connect(product.y, wall.Q_gen) annotation (Line(points={{-5.6,18},{-4,18},{-4,
          8},{-16,8},{-16,5},{-11,5}},     color={0,0,127}));
  connect(product1.y, wall1.Q_gen) annotation (Line(points={{-3.6,-14},{-2,-14},
          {-2,-22},{-16,-22},{-16,-25},{-11,-25}},      color={0,0,127}));
  connect(product2.y, wall2.Q_gen) annotation (Line(points={{-3.6,-44},{-2,-44},
          {-2,-52},{-16,-52},{-16,-55},{-11,-55}},      color={0,0,127}));
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
  annotation (experiment(__Dymola_NumberOfIntervals=1));
end Figure_1_8_UniformThermalEnergyGeneration_Plane;
