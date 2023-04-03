within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein;
model Example_2_2_1_2DFin
  "Uniform thermaly energy generation in a plane wall (Figure 1-8) | pg. 28"
  import TRANSFORM;
  extends Icons.Example;
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_base[
    nNodes_2.k](each T=473.15)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.Constant L(each k=0.05) "Length of fin"
    annotation (Placement(transformation(extent={{-100,72},{-92,80}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=20)
    annotation (Placement(transformation(extent={{-78,80},{-70,88}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_2(k=10)
    annotation (Placement(transformation(extent={{-64,80},{-56,88}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_inf[
    nNodes_1.k](each T=293.15)
    annotation (Placement(transformation(extent={{-30,-80},{-10,-60}})));
  Modelica.Blocks.Sources.Constant th(each k=0.04) "thickness of fin"
    annotation (Placement(transformation(extent={{-100,58},{-92,66}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic bound_right[
    nNodes_2.k]
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic
    bound_symmetry[nNodes_1.k] annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,50})));
  Resistances.Heat.Convection convection[nNodes_1.k](each alpha=100,
      surfaceArea=fin.geometry.crossAreas_2[:, 1]) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-30})));
  TRANSFORM.Utilities.Visualizers.Outputs.SpatialPlot Temperature_y0(
    minX=0,
    maxX=0.05,
    minY=20,
    maxY=200,
    x=xval,
    y=yval) "X - Axial Location (m) | T - Temperature (C) - Bottom Boundary"
    annotation (Placement(transformation(extent={{16,-76},{58,-36}})));
  TRANSFORM.Utilities.Visualizers.Outputs.SpatialPlot Temperature_y_th_half(
    minX=0,
    maxX=0.05,
    minY=20,
    maxY=200,
    x=xval2,
    y=yval2) "X - Axial Location (m) | T - Temperature (C) - Top Boundary"
    annotation (Placement(transformation(extent={{62,-76},{104,-36}})));
  DiscritizedModels.Conduction_2D fin(
    exposeState_a1=false,
    exposeState_b1=true,
    exposeState_a2=true,
    exposeState_b2=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_2D (
        nX=nNodes_1.k,
        nY=nNodes_2.k,
        length_x=L.y,
        length_y=0.5*th.y,
        length_z=1),
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_0_5_d_7990_cp_500,
    redeclare model ConductionModel =
        TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2.ForwardDifference_1O,
    adiabaticDims={true,false})
            annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
 Real xval[nNodes_1.k] = fin.geometry.cs_1[:, 1];
  Real yval[nNodes_1.k]=
      TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(fin.materials[
      :, 1].T);
 Real xval2[nNodes_1.k] = fin.geometry.cs_1[:, nNodes_2.k];
  Real yval2[nNodes_1.k]=
      TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(fin.materials[
      :, nNodes_2.k].T);
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={yval[5],yval[15]})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(T_inf.port, convection.port_b) annotation (Line(points={{-10,-70},{0,
          -70},{0,-37}},    color={191,0,0}));
  connect(fin.port_b1, bound_right.port)
    annotation (Line(points={{10,0},{40,0}},        color={191,0,0}));
  connect(fin.port_b2, bound_symmetry.port)
    annotation (Line(points={{0,10},{0,25},{0,40}}, color={191,0,0}));
  connect(T_base.port, fin.port_a1)
    annotation (Line(points={{-40,0},{-25,0},{-10,0}}, color={191,0,0}));
  connect(convection.port_a, fin.port_a2)
    annotation (Line(points={{0,-23},{0,-23},{0,-10}}, color={191,0,0}));
  annotation (experiment(__Dymola_NumberOfIntervals=100));
end Example_2_2_1_2DFin;
