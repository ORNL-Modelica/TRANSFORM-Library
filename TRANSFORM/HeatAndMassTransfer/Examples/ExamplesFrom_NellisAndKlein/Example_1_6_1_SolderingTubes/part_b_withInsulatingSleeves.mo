within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein.Example_1_6_1_SolderingTubes;
model part_b_withInsulatingSleeves
  "part b) Add insulating sleeves to reduce the necessary soldering power"
  extends Icons.Example;

  Modelica.Blocks.Sources.Constant L(each k=
        Units.Conversions.Functions.Distance_m.from_feet(2.5)) "Length"
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  Modelica.Blocks.Sources.Constant D_in(each k=
        Units.Conversions.Functions.Distance_m.from_inch(4)) "inner diameter"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  Modelica.Blocks.Sources.Constant th(each k=
        Units.Conversions.Functions.Distance_m.from_inch(0.375)) "thickness"
    annotation (Placement(transformation(extent={{-100,56},{-92,64}})));
  Modelica.Blocks.Sources.Constant lambda(each k=150) "thermal conductivity"
    annotation (Placement(transformation(extent={{-100,42},{-92,50}})));
  FinEfficiency.GenericFin genericFin(
    alpha=alpha.y,
    lambda=lambda.y,
    perimeter=(D_in.y + 2*th.y)*Modelica.Constants.pi,
    crossArea=0.25*Modelica.Constants.pi*((D_in.y + 2*th.y)^2 - D_in.y^2),
    L=L.y - L_ins.y)
    annotation (Placement(transformation(extent={{-20,-70},{20,-30}})));
  Modelica.Blocks.Sources.Constant alpha(each k=20) "heat transfer coefficient"
    annotation (Placement(transformation(extent={{-100,28},{-92,36}})));
  Resistances.Heat.Fin pipe_left(
    eta=genericFin.eta,
    surfaceArea=genericFin.surfaceArea,
    alpha=alpha.y)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Resistances.Heat.Fin pipe_right(
    eta=genericFin.eta,
    surfaceArea=genericFin.surfaceArea,
    alpha=alpha.y)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  BoundaryConditions.Heat.Temperature T_infinity_left(T=293.15)
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  BoundaryConditions.Heat.Temperature T_infinity_right(T=293.15)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  BoundaryConditions.Heat.Temperature T_melt(T=503.15) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,30})));
  Resistances.Heat.Plane insulation_left(
    lambda=lambda.y,
    crossArea=genericFin.crossArea,
    L=L_ins.y)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Resistances.Heat.Plane insulation_right(
    lambda=lambda.y,
    crossArea=genericFin.crossArea,
    L=L_ins.y) annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Modelica.Blocks.Sources.Constant
                               L_ins(k=0.16)
                 "Length of insulation"
    annotation (Placement(transformation(extent={{-84,76},{-76,84}})));

  Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={-T_melt.port.Q_flow})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(T_infinity_left.port, pipe_left.port_a)
    annotation (Line(points={{-68,0},{-57,0}}, color={191,0,0}));
  connect(T_infinity_right.port, pipe_right.port_b)
    annotation (Line(points={{70,0},{57,0}}, color={191,0,0}));
  connect(pipe_left.port_b, insulation_left.port_a)
    annotation (Line(points={{-43,0},{-43,0},{-27,0}}, color={191,0,0}));
  connect(insulation_left.port_b, insulation_right.port_a)
    annotation (Line(points={{-13,0},{13,0}}, color={191,0,0}));
  connect(insulation_right.port_b, pipe_right.port_a)
    annotation (Line(points={{27,0},{27,0},{43,0}}, color={191,0,0}));
  connect(T_melt.port, insulation_right.port_a)
    annotation (Line(points={{0,20},{0,0},{13,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=10,
      __Dymola_NumberOfIntervals=100,
      __Dymola_Algorithm="Dassl"));
end part_b_withInsulatingSleeves;
