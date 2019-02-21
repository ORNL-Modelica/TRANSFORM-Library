within TRANSFORM.Controls.Examples.FeedForward;
model getOpening_ValveIncompressible_Test
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  package Medium = Modelica.Media.Water.StandardWater;
  Modelica.Fluid.Sources.Boundary_pT
    pressureBoundary_h(
    use_p_in=true,
    p=8000000,
    T=413.15,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Fluid.Sources.Boundary_ph
    pressureBoundary_h1(
    h=1e5,
    use_h_in=false,
    p=7000000,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    nPorts=1)
    annotation (Placement(transformation(extent={{62,-10},{42,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=min(1, 0.5 +
        time*0.1))
    annotation (Placement(transformation(extent={{-28,12},{-8,32}})));
  Modelica.Blocks.Sources.Constant const(k=80e5)
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=1,
    offset=0,
    amplitude=1e5)
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-70,48},{-50,68}})));
  Modelica.Fluid.Valves.ValveIncompressible valve(
    m_flow_nominal=2,
    redeclare package Medium = Modelica.Media.Water.StandardWater,
    dp_nominal=500000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Utilities.Visualizers.displayReal actual(
    use_port=false,
    val=valve.opening,
    precision=2)
    annotation (Placement(transformation(extent={{60,-58},{80,-38}})));
  Utilities.Visualizers.displayReal predicted(
    use_port=false,
    val=getOpening.y,
    precision=2)
    annotation (Placement(transformation(extent={{60,-82},{80,-62}})));
  TRANSFORM.Controls.FeedForward.getOpening_ValveIncompressible getOpening(
    dp_nom=valve.dp_nominal,
    m_flow_nom=valve.m_flow_nominal,
    dp=valve.dp,
    m_flow_ref=valve.m_flow,
    d_nom=valve.rho_nominal,
    d=Medium.density_pT(pressureBoundary_h.p, pressureBoundary_h.T))
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={actual.val,
        predicted.val})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(sine.y, add.u1) annotation (Line(points={{-79,70},{-72,70},{-72,64}},
                color={0,0,127}));
  connect(const.y, add.u2) annotation (Line(points={{-79,40},{-72,40},{-72,52}},
                    color={0,0,127}));
  connect(add.y, pressureBoundary_h.p_in) annotation (Line(points={{-49,58},{
          -40,58},{-40,20},{-80,20},{-80,8},{-62,8}}, color={0,0,127}));
  connect(pressureBoundary_h.ports[1], valve.port_a)
    annotation (Line(points={{-40,0},{-25,0},{-10,0}}, color={0,127,255}));
  connect(valve.port_b, pressureBoundary_h1.ports[1])
    annotation (Line(points={{10,0},{26,0},{42,0}}, color={0,127,255}));
  connect(realExpression.y, valve.opening)
    annotation (Line(points={{-7,22},{0,22},{0,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={
                                      Text(
          extent={{56,-36},{86,-42}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          fillColor={216,112,112},
          fillPattern=FillPattern.Solid,
          textString="Valve opening reference"),
                                      Text(
          extent={{56,-62},{84,-66}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5,
          fillColor={216,112,112},
          fillPattern=FillPattern.Solid,
          textString="Valve opening FF")}),
    experiment(StopTime=10));
end getOpening_ValveIncompressible_Test;
