within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein;
model Example_1_6_2_ThermoelectricHeatSink
  "part a) Estimate heat transfer through finned surface"
  extends Icons.Example;

  Modelica.Blocks.Sources.Constant L_fin(each k=0.015) "fin length"
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  Modelica.Blocks.Sources.Constant D_fin(each k=0.0015) "fin diameter"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  Modelica.Blocks.Sources.Constant W_b(each k=0.03) "base width"
    annotation (Placement(transformation(extent={{-100,56},{-92,64}})));
  Modelica.Blocks.Sources.Constant lambda_fin(each k=70) "thermal conductivity"
    annotation (Placement(transformation(extent={{-72,84},{-64,92}})));
  FinEfficiency.GenericFin genericFin(
    alpha=alpha.y,
    lambda=lambda_fin.y,
    L=L_fin.y,
    crossArea=0.25*Modelica.Constants.pi*D_fin.y^2,
    perimeter=D_fin.y*Modelica.Constants.pi)
    annotation (Placement(transformation(extent={{-20,-96},{20,-56}})));
  Modelica.Blocks.Sources.Constant alpha(each k=50) "heat transfer coefficient"
    annotation (Placement(transformation(extent={{-72,56},{-64,64}})));
  Resistances.Heat.Fin fin(
    eta=genericFin.eta,
    alpha=alpha.y,
    surfaceArea=N_fins.y*genericFin.surfaceArea)
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  BoundaryConditions.Heat.Temperature T_hot(T=303.15) "temperature under base"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  BoundaryConditions.Heat.Temperature T_infinity(T=293.15)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.Constant th_b(each k=0.002) "base thickness"
    annotation (Placement(transformation(extent={{-100,42},{-92,50}})));
  Modelica.Blocks.Sources.Constant lambda_b(each k=25) "thermal conductivity"
    annotation (Placement(transformation(extent={{-72,70},{-64,78}})));
  Resistances.Heat.Contact contact(Rc_pp=1e-4, surfaceArea=N_fins.y*genericFin.crossArea)
    annotation (Placement(transformation(extent={{-12,10},{8,30}})));
  Modelica.Blocks.Sources.Constant N_fins(each k=100) "number of fins"
    annotation (Placement(transformation(extent={{-72,42},{-64,50}})));
  Resistances.Heat.Convection un_finned(alpha=alpha.y, surfaceArea=W_b.y^2 -
        N_fins.y*genericFin.crossArea)
    annotation (Placement(transformation(extent={{4,-30},{24,-10}})));
  Resistances.Heat.Plane base(
    L=th_b.y,
    crossArea=W_b.y^2,
    lambda=lambda_b.y)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={T_infinity.port.Q_flow})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(T_hot.port, base.port_a)
    annotation (Line(points={{-60,0},{-47,0},{-47,0}}, color={191,0,0}));
  connect(base.port_b, contact.port_a) annotation (Line(points={{-33,0},{-20,0},
          {-20,20},{-9,20}},  color={191,0,0}));
  connect(contact.port_b, fin.port_a)
    annotation (Line(points={{5,20},{5,20},{23,20}},  color={191,0,0}));
  connect(fin.port_b, T_infinity.port)
    annotation (Line(points={{37,20},{50,20},{50,0},{60,0}}, color={191,0,0}));
  connect(un_finned.port_b, T_infinity.port) annotation (Line(points={{21,-20},
          {50,-20},{50,0},{60,0}}, color={191,0,0}));
  connect(un_finned.port_a, contact.port_a) annotation (Line(points={{7,-20},{
          -20,-20},{-20,20},{-9,20}},  color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=10,
      __Dymola_NumberOfIntervals=100,
      __Dymola_Algorithm="Dassl"));
end Example_1_6_2_ThermoelectricHeatSink;
