within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein.Example_1_7_1_BentBeamActuator;
model part_b_TemperatureAndPosition
  "part b) Determine the temperature as a function of position on the beam"
  import TRANSFORM;
  extends Icons.Example;
  Modelica.Blocks.Sources.Constant L_a(each k=0.001) "distance between anchors"
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  Modelica.Blocks.Sources.Constant w(each k=10e-6) "beam width"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  Modelica.Blocks.Sources.Constant th(each k=5e-6) "beam thickness"
    annotation (Placement(transformation(extent={{-100,56},{-92,64}})));
  Modelica.Blocks.Sources.Constant alpha(each k=100)
    "heat transfer coefficient"
    annotation (Placement(transformation(extent={{-72,84},{-64,92}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_anchor_a(
      T=293.15) "anchor temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.Constant I(each k=0.01) "current"
    annotation (Placement(transformation(extent={{-100,42},{-92,50}})));
  Modelica.Blocks.Sources.Constant rho_e(each k=1e-5) "electrical resistivity"
    annotation (Placement(transformation(extent={{-72,70},{-64,78}})));
  Modelica.Blocks.Sources.Constant theta(each k=0.5) "beam slope"
    annotation (Placement(transformation(extent={{-100,28},{-92,36}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_infinity[
    nNodes_1.k](each T=293.15) "ambient temperature"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.Constant CTR(each k=3.5e-6)
    "coefficient of thermal expansion"
    annotation (Placement(transformation(extent={{-72,56},{-64,64}})));
  DiscritizedModels.Conduction_1D beam(
    exposeState_a1=false,
    exposeState_b1=true,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_1D (
        length_y=th.y,
        nX=nNodes_1.k,
        length_z=w.y,
        length_x=L.y),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_80_d_7990_cp_500,
    T_a1_start=293.15,
    redeclare model InternalHeatModel =
        DiscritizedModels.BaseClasses.Dimensions_1.VolumetricHeatGeneration (
          q_ppps={I.y^2*R_e[i].y/(2*L.y*beam.geometry.crossAreas_1[i]) for i in
                1:nNodes_1.k}))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=20)
    annotation (Placement(transformation(extent={{-40,84},{-32,92}})));
  Resistances.Heat.Convection convection[nNodes_1.k](each alpha=alpha.y,
      surfaceArea=beam.geometry.surfaceAreas_23)
    annotation (Placement(transformation(extent={{-20,-50},{-40,-30}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic adiabatic
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Blocks.Sources.RealExpression L(y=0.5*L_a.y/Modelica.Math.cos(theta.y))
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Modelica.Blocks.Sources.RealExpression R_e[nNodes_1.k](y={rho_e.y*2*L.y/beam.geometry.crossAreas_1
        [i] for i in 1:nNodes_1.k})
    annotation (Placement(transformation(extent={{-10,56},{10,76}})));
  TRANSFORM.Utilities.Visualizers.Outputs.SpatialPlot TemperaturePosition(
    minX=0,
    x=xval,
    y=yval,
    maxX=1,
    minY=0,
    maxY=800) "X - Dimensionless position (-) | T - Temperature (C)"
    annotation (Placement(transformation(extent={{16,-76},{58,-36}})));
 Real xval[nNodes_1.k] = beam.geometry.cs_1/L.y;
  Real yval[nNodes_1.k]=
      TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(beam.materials.T);
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={beam.materials[
        end].T})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(T_anchor_a.port, beam.port_a1)
    annotation (Line(points={{-60,0},{-10,0}}, color={191,0,0}));
  connect(T_infinity.port, convection.port_b) annotation (Line(points={{-60,-40},
          {-60,-40},{-37,-40}},          color={191,0,0}));
  connect(adiabatic.port, beam.port_b1)
    annotation (Line(points={{40,0},{10,0}}, color={191,0,0}));
  connect(convection.port_a, beam.port_external) annotation (Line(points={{-23,-40},
          {-8,-40},{-8,-8}},            color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=10,
      __Dymola_NumberOfIntervals=100,
      __Dymola_Algorithm="Dassl"));
end part_b_TemperatureAndPosition;
