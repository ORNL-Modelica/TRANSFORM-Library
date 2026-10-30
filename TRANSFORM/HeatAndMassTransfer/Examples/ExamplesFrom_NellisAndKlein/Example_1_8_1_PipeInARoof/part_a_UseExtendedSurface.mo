within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein.Example_1_8_1_PipeInARoof;
model part_a_UseExtendedSurface
  "part a) Determine if it appropriate to use an extended surface"
  extends Icons.Example;
  BoundaryConditions.Heat.Temperature T_hot(T=363.15) "hot gas temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  BoundaryConditions.Heat.Temperature T_infinity(T=293.15)
    "ambient temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Utilities.CharacteristicNumbers.Models.BiotNumber biotNumber(
    alpha=alpha.y,
    lambda=lambda.y,
    L=th.y)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant r_p(each k=0.05) "pipe radius"
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  Modelica.Blocks.Sources.Constant th(each k=0.02) "beam thickness"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  Modelica.Blocks.Sources.Constant lambda(each k=50) "thermal conductivity"
    annotation (Placement(transformation(extent={{-72,84},{-64,92}})));
  Modelica.Blocks.Sources.Constant alpha(each k=50)
    "heat transfer coefficient"
    annotation (Placement(transformation(extent={{-72,70},{-64,78}})));
  Modelica.Blocks.Sources.Constant qf_s(each k=800) "solar flux"
    annotation (Placement(transformation(extent={{-72,56},{-64,64}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={biotNumber.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=10,
      __Dymola_NumberOfIntervals=100,
      __Dymola_Algorithm="Dassl"));
end part_a_UseExtendedSurface;
