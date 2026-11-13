within TRANSFORM.HeatExchangers.Examples.IncroperaAndDeWitt;
model Example_11_1_Q
  "Incropera and DeWitt Example 11.1: heat rate from the thermal conductance UA (LMTD_HX_Q)"
  extends TRANSFORM.Icons.Example;
  package Medium_oil = Modelica.Media.Water.ConstantPropertyLiquidWater (
      mediumName="Engine oil, constant cp", cp_const=2131) "Hot side: engine oil, cp as in the book";
  package Medium_water = Modelica.Media.Water.ConstantPropertyLiquidWater (
      mediumName="Water, constant cp", cp_const=4178) "Cold side: water, cp as in the book";

  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T boundary_a1(
    redeclare package Medium = Medium_oil,
    m_flow=0.1,
    T=373.15,
    nPorts=1) "Oil inlet"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT boundary_b1(
    redeclare package Medium = Medium_oil,
    p=100000,
    T=333.15,
    nPorts=1) "Oil outlet"
    annotation (Placement(transformation(extent={{60,10},{40,30}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T boundary_a2(
    redeclare package Medium = Medium_water,
    m_flow=0.2,
    T=303.15,
    nPorts=1) "Water inlet"
    annotation (Placement(transformation(extent={{60,-30},{40,-10}})));
  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT boundary_b2(
    redeclare package Medium = Medium_water,
    p=100000,
    T=313.35,
    nPorts=1) "Water outlet"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  TRANSFORM.HeatExchangers.LMTD_HX_Q lmtd_HX(
    redeclare package Medium_1 = Medium_oil,
    redeclare package Medium_2 = Medium_water,
    m_flow_start_1=0.1,
    m_flow_start_2=0.2,
    UA0=38.1*5.178) "The book's U times A"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(
    n=3,
    x={lmtd_HX.Q_flow,lmtd_HX.sensor_T_b1.T,lmtd_HX.sensor_T_b2.T},
    x_reference={8524,333.15,313.35}) "Reference values are the book's answers"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(boundary_a1.ports[1], lmtd_HX.port_a1) annotation (Line(points={{-40,20},
          {-16,20},{-16,4},{-10,4}}, color={0,127,255}));
  connect(lmtd_HX.port_b1, boundary_b1.ports[1]) annotation (Line(points={{10,4},
          {16,4},{16,20},{40,20}}, color={0,127,255}));
  connect(boundary_a2.ports[1], lmtd_HX.port_a2) annotation (Line(points={{40,-20},
          {16,-20},{16,-4},{10,-4}}, color={0,127,255}));
  connect(lmtd_HX.port_b2, boundary_b2.ports[1]) annotation (Line(points={{-10,-4},
          {-16,-4},{-16,-20},{-40,-20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1),
    Documentation(info="<html>
<p>Example 11.1 (pp. 680-682) of <i>Fundamentals of Heat and Mass Transfer</i> by Incropera and DeWitt: a counterflow, concentric tube heat exchanger cools engine oil (side 1, 0.1 kg/s, 100 &deg;C to 60 &deg;C) with water (side 2, 0.2 kg/s, 30 &deg;C in). The book uses constant specific heats (oil 2131 J/(kg.K), water 4178 J/(kg.K)) and finds q = 8524 W, a water outlet temperature of 40.2 &deg;C, a log mean temperature difference of 43.2 K and, with U = 38.1 W/(m2.K), a heat transfer area of 5.178 m2.</p>
<p>LMTD_HX_Q is given the thermal conductance UA and returns the heat rate and both outlet temperatures.</p>
</html>"));
end Example_11_1_Q;
