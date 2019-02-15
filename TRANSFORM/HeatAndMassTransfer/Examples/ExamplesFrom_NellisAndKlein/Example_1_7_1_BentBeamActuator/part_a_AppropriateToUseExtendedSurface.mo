within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein.Example_1_7_1_BentBeamActuator;
model part_a_AppropriateToUseExtendedSurface
  "part a) Determine if it appropriate to use an extended surface"
  extends Icons.Example;
  BoundaryConditions.Heat.Temperature T_anchor_a(T=293.15) "anchor temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  BoundaryConditions.Heat.Temperature T_anchor_b(T=293.15) "anchor temperature"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  BoundaryConditions.Heat.Temperature T_infinity(T=293.15)
    "ambient temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Utilities.CharacteristicNumbers.Models.BiotNumber biotNumber(
    alpha=alpha.y,
    L=0.5*th.y,
    lambda=lambda.y)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant L_a(each k=0.001) "distance between anchors"
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  Modelica.Blocks.Sources.Constant w(each k=10e-6) "beam width"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  Modelica.Blocks.Sources.Constant th(each k=5e-6) "beam thickness"
    annotation (Placement(transformation(extent={{-100,56},{-92,64}})));
  Modelica.Blocks.Sources.Constant lambda(each k=80) "thermal conductivity"
    annotation (Placement(transformation(extent={{-72,84},{-64,92}})));
  Modelica.Blocks.Sources.Constant alpha(each k=100)
    "heat transfer coefficient"
    annotation (Placement(transformation(extent={{-72,70},{-64,78}})));
  Modelica.Blocks.Sources.Constant I(each k=0.01) "current"
    annotation (Placement(transformation(extent={{-100,42},{-92,50}})));
  Modelica.Blocks.Sources.Constant rho_e(each k=1e-5) "electrical resistivity"
    annotation (Placement(transformation(extent={{-72,56},{-64,64}})));
  Modelica.Blocks.Sources.Constant theta(each k=0.5) "beam slope"
    annotation (Placement(transformation(extent={{-100,28},{-92,36}})));
  Modelica.Blocks.Sources.Constant CTR(each k=3.5e-6)
    "coefficient of thermal expansion"
    annotation (Placement(transformation(extent={{-72,42},{-64,50}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={biotNumber.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=10,
      __Dymola_NumberOfIntervals=100,
      __Dymola_Algorithm="Dassl"));
end part_a_AppropriateToUseExtendedSurface;
