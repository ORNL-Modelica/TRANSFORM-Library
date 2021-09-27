within TRANSFORM.HeatAndMassTransfer.Examples.WindingDiscretizedModels;
model Winding_123D
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  DiscritizedModels.Conduction_3D winding(
    exposeState_a1=true,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_3D (
        r_inner=0.01,
        r_outer=0.02,
        length_z=0.03,
        nR=nNodes_1.k,
        nTheta=nNodes_2.k,
        nZ=nNodes_3.k),
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_28_5_d_7990_cp_500,
    T_a1_start(displayUnit="K") = 320,
    T_a2_start(displayUnit="K") = 320,
    T_a3_start(displayUnit="K") = 320,
    exposeState_b1=true,
    exposeState_a3=true,
    exposeState_b3=true,
    exposeState_a2=true,
    exposeState_b2=true,
    redeclare model InternalHeatModel =
        DiscritizedModels.BaseClasses.Dimensions_3.VolumetricHeatGeneration (
          q_ppp=6e5))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=10)
    annotation (Placement(transformation(extent={{-98,88},{-90,96}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_2(k=3)
    annotation (Placement(transformation(extent={{-84,88},{-76,96}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_3(k=10)
    annotation (Placement(transformation(extent={{-68,88},{-60,96}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_inf_inner[
    nNodes_2.k,nNodes_3.k](each T=320)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic bound_bottom[
    nNodes_1.k,nNodes_2.k] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=45,
        origin={-36,-36})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_inf[
    nNodes_1.k,nNodes_2.k](each T=320) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=45,
        origin={50,50})));
  Resistances.Heat.Convection convection_inner[nNodes_2.k,nNodes_3.k](each
      alpha=400, surfaceArea=winding.geometry.crossAreas_1[1, :, :])
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-40,0})));
  Resistances.Heat.Convection convection_top[nNodes_1.k,nNodes_2.k](each alpha=
        400, surfaceArea=winding.geometry.crossAreas_3[:, :, end]) annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=45,
        origin={28,28})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic bound_outer[
    nNodes_2.k,nNodes_3.k]
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Utilities.Visualizers.displayReal display(use_port=true)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Blocks.Sources.RealExpression T_max(y=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(max(winding.materials.T)))
    annotation (Placement(transformation(extent={{-38,-66},{-22,-54}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic bound_inner[
    nNodes_1.k,nNodes_3.k] annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-38})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic bound_outer2[
    nNodes_1.k,nNodes_3.k] annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,70})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={winding.materials[
        3, 2, 8].T})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(T_inf_inner.port, convection_inner.port_b)
    annotation (Line(points={{-60,0},{-47,0},{-47,0}}, color={191,0,0}));
  connect(convection_inner.port_a, winding.port_a1)
    annotation (Line(points={{-33,0},{-33,0},{-10,0}}, color={191,0,0}));
  connect(convection_top.port_b, T_inf.port) annotation (Line(points={{32.9497,
          32.9497},{42.9289,42.9289}}, color={191,0,0}));
  connect(bound_bottom.port, winding.port_a3)
    annotation (Line(points={{-28.9289,-28.9289},{-8,-8}}, color={191,0,0}));
  connect(winding.port_b1, bound_outer.port)
    annotation (Line(points={{10,0},{25,0},{40,0}}, color={191,0,0}));
  connect(winding.port_b3, convection_top.port_a)
    annotation (Line(points={{8,8},{23.0503,23.0503}}, color={191,0,0}));
  connect(T_max.y, display.u)
    annotation (Line(points={{-21.2,-60},{-11.5,-60}}, color={0,0,127}));
  connect(bound_outer2.port, winding.port_b2)
    annotation (Line(points={{0,60},{0,35},{0,10}}, color={191,0,0}));
  connect(bound_inner.port, winding.port_a2)
    annotation (Line(points={{0,-28},{0,-28},{0,-10}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=100, __Dymola_NumberOfIntervals=100));
end Winding_123D;
