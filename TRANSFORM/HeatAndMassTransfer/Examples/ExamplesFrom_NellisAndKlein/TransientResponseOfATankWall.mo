within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein;
model TransientResponseOfATankWall
  "Example 3.3-1 Transient response of a tank wall pp. 351-354"
  import TRANSFORM;
  extends Icons.Example;
  Modelica.Blocks.Sources.Constant alpha_fluid(each k=5000)
    "heat transfer coefficient"
    annotation (Placement(transformation(extent={{-54,84},{-46,92}})));
  Modelica.Blocks.Sources.Constant th(each k=0.008) "thickness"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  Modelica.Blocks.Sources.Constant lambda(each k=20) "thermal conductivity"
    annotation (Placement(transformation(extent={{-68,84},{-60,92}})));
  Modelica.Blocks.Sources.Constant d(each k=8000) "density"
    annotation (Placement(transformation(extent={{-68,70},{-60,78}})));
  Modelica.Blocks.Sources.Constant cp(each k=400) "heat capacity"
    annotation (Placement(transformation(extent={{-54,70},{-46,78}})));
  Modelica.Blocks.Sources.Constant Thot(k=500) "hot temperature"
    annotation (Placement(transformation(extent={{-84,84},{-76,92}})));
  Modelica.Blocks.Sources.Constant Tcold(k=400) "cold temperature"
    annotation (Placement(transformation(extent={{-84,70},{-76,78}})));
  Modelica.Blocks.Sources.Constant Ac(k=1)
    "cross sectional area perpindular to heat transfer"
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  DiscritizedModels.Conduction_1D wall(
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_1D (
                                                                       nX=
            nNodes_1.k, length_x=th.y),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    exposeState_a1=true,
    exposeState_b1=true,
    T_a1_start=Tcold.k,
    T_b1_start=Thot.k,
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_20_d_8000_cp_400)
    annotation (Placement(transformation(extent={{2,10},{22,30}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=10)
    annotation (Placement(transformation(extent={{-26,84},{-18,92}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature cold_tank(
      use_port=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-44,20})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature hot_tank(
      use_port=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={68,20})));
  Resistances.Heat.Convection convection1(surfaceArea=wall.geometry.crossAreas_1
        [1], alpha=alpha_tanks.y)
    annotation (Placement(transformation(extent={{-8,10},{-28,30}})));
  Resistances.Heat.Convection convection2(surfaceArea=wall.geometry.crossAreas_1
        [end], alpha=alpha_tanks.y)
    annotation (Placement(transformation(extent={{32,10},{52,30}})));
  Modelica.Blocks.Sources.Step Thot_tank(offset=Thot.k, height=-200,
    startTime=0.1)
    "hot temperature"
    annotation (Placement(transformation(extent={{-100,42},{-92,50}})));
  Modelica.Blocks.Sources.Step Tcold_tank(height=-100, offset=Tcold.k,
    startTime=0.1)
    "cold temperature"
    annotation (Placement(transformation(extent={{-100,28},{-92,36}})));
  Modelica.Blocks.Sources.Step alpha_tanks(              offset=alpha_fluid.k,
    height=alpha_gas.k - alpha_fluid.k,
    startTime=0.1)
    "heat transfer coefficient"
    annotation (Placement(transformation(extent={{-84,36},{-76,44}})));
  Utilities.CharacteristicNumbers.Models.DiffusiveHeatTimeConstant tau_diff(
    L=th.y,
    d=d.y,
    cp=cp.y,
    lambda=lambda.y)
    annotation (Placement(transformation(extent={{-60,-56},{-40,-36}})));
  Utilities.Visualizers.displayReal display_tau_diff(use_port=true)
    annotation (Placement(transformation(extent={{-30,-56},{-10,-36}})));
  Utilities.CharacteristicNumbers.Models.LumpedHeatTimeConstant tau_lumped(
    d=d.y,
    cp=cp.y,
    V=Ac.y*th.y,
    R=1/(2*Ac.y*alpha_gas.y))
    annotation (Placement(transformation(extent={{-60,-84},{-40,-64}})));
  Utilities.Visualizers.displayReal display_tau_lumped(use_port=true)
    annotation (Placement(transformation(extent={{-30,-84},{-10,-64}})));
  Modelica.Blocks.Sources.Constant alpha_gas(each k=100)
    "heat transfer coefficient"
    annotation (Placement(transformation(extent={{-40,84},{-32,92}})));
  UserInteraction.Outputs.SpatialPlot wallTemperature(
    minX=0,
    maxX=0.8,
    maxY=475,
    y=wall.materials.T,
    x=wall.geometry.cs_1*100,
    minY=400) "X - Axial Location (cm) | T - Temperature (K)"
    annotation (Placement(transformation(extent={{10,-86},{64,-32}})));
  Modelica.Blocks.Sources.RealExpression T_hot(y=Thot_tank.y)
    annotation (Placement(transformation(extent={{100,10},{80,30}})));
  Modelica.Blocks.Sources.RealExpression T_cold(y=Tcold_tank.y)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={wall.summary.T_effective})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(wall.port_b1, convection2.port_a)
    annotation (Line(points={{22,20},{35,20}},   color={191,0,0}));
  connect(wall.port_a1, convection1.port_a)
    annotation (Line(points={{2,20},{-11,20}},              color={191,0,0}));
  connect(cold_tank.port, convection1.port_b)
    annotation (Line(points={{-34,20},{-25,20}},   color={191,0,0}));
  connect(hot_tank.port, convection2.port_b)
    annotation (Line(points={{58,20},{49,20}},            color={191,0,0}));
  connect(tau_diff.y, display_tau_diff.u)
    annotation (Line(points={{-39,-46},{-31.5,-46}}, color={0,0,127}));
  connect(tau_lumped.y, display_tau_lumped.u)
    annotation (Line(points={{-39,-74},{-31.5,-74}}, color={0,0,127}));
  connect(T_cold.y, cold_tank.T_ext)
    annotation (Line(points={{-59,20},{-53.5,20},{-48,20}}, color={0,0,127}));
  connect(T_hot.y, hot_tank.T_ext)
    annotation (Line(points={{79,20},{75.5,20},{72,20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{18,-26},{56,-32}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="The wall equilibrates quickly internally
with the low convection coefficient when
gas enters the tanks and then drops
approximately uniformly there after.")}),
    experiment(StopTime=50));
end TransientResponseOfATankWall;
