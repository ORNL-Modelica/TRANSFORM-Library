within TRANSFORM.HeatAndMassTransfer.Examples.WindingDiscretizedModels;
model Winding_12D_variableArea
  import TRANSFORM;
  extends Modelica.Icons.Example;

  DiscritizedModels.Conduction_2D winding(
    exposeState_a1=true,
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_28_5_d_7990_cp_500,
    exposeState_b1=true,
    exposeState_b2=true,
    T_a1_start(displayUnit="K") = 320,
    T_a2_start(displayUnit="K") = 320,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_2D_r_z
        (
        nR=nNodes_1.k,
        nZ=nNodes_2.k,
        r_inner=r_inner.y,
        r_outer=r_outer.y,
        length_z=length_z.y),
    redeclare model InternalHeatModel =
        DiscritizedModels.BaseClasses.Dimensions_2.VolumetricHeatGeneration (
          q_ppp=6e5))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=5)
    annotation (Placement(transformation(extent={{-98,88},{-90,96}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_2(k=10)
    annotation (Placement(transformation(extent={{-84,88},{-76,96}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_inf_inner[
    nNodes_2.k](each T=320)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic bound_bottom[
    nNodes_1.k] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-30})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_inf[
    nNodes_1.k](each T=320) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,56})));
  Resistances.Heat.Convection convection_inner[nNodes_2.k](each alpha=400,
      surfaceArea=winding.geometry.crossAreas_1[1, :]) annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-40,0})));
  Resistances.Heat.Convection convection_top[nNodes_1.k](each alpha=400,
      surfaceArea=winding.geometry.crossAreas_2[:, end]) annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={0,30})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic bound_outer[
    nNodes_2.k]
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));

  Real hA_val_inner[nNodes_2.k];
  Real hA_val_top[nNodes_1.k];
  Utilities.Visualizers.displayReal display(use_port=true)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Blocks.Sources.RealExpression T_max(y=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(max(winding.materials.T)))
    annotation (Placement(transformation(extent={{-38,-66},{-22,-54}})));
  Modelica.Blocks.Sources.Sine r_inner(
    offset=0.01,
    freqHz=1/50,
    amplitude=0.005)
    annotation (Placement(transformation(extent={{-100,60},{-90,70}})));
  Modelica.Blocks.Sources.Sine r_outer(
    offset=0.02,
    freqHz=1/50,
    amplitude=0.005,
    startTime=10)
    annotation (Placement(transformation(extent={{-100,42},{-90,52}})));
  Modelica.Blocks.Sources.Sine length_z(
    offset=0.03,
    freqHz=1/50,
    amplitude=0.01,
    startTime=20)
    annotation (Placement(transformation(extent={{-100,24},{-90,34}})));

  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={T_max.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation

  for j in 1:nNodes_2.k loop
    hA_val_inner[j] = 400*winding.geometry.crossAreas_1[1, j];
  end for;

  for i in 1:nNodes_1.k loop
    hA_val_top[i] = 400*winding.geometry.crossAreas_2[i, nNodes_2.k];
  end for;

  connect(T_max.y, display.u)
    annotation (Line(points={{-21.2,-60},{-11.5,-60}}, color={0,0,127}));
  connect(T_inf_inner.port, convection_inner.port_b)
    annotation (Line(points={{-60,0},{-47,0},{-47,0}}, color={191,0,0}));
  connect(convection_inner.port_a, winding.port_a1) annotation (Line(points={{-33,
          -1.33227e-015},{-20,-1.33227e-015},{-20,0},{-10,0}}, color={191,0,0}));
  connect(convection_top.port_a, winding.port_b2)
    annotation (Line(points={{0,23},{0,23},{0,10}}, color={191,0,0}));
  connect(bound_outer.port, winding.port_b1)
    annotation (Line(points={{40,0},{10,0}},        color={191,0,0}));
  connect(winding.port_a2, bound_bottom.port)
    annotation (Line(points={{0,-10},{0,-15},{0,-20}}, color={191,0,0}));
  connect(T_inf.port, convection_top.port_b)
    annotation (Line(points={{0,46},{0,37}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=100, __Dymola_NumberOfIntervals=100));
end Winding_12D_variableArea;
