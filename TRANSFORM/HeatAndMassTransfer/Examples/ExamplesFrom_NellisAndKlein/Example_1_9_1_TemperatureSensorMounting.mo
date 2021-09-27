within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein;
model Example_1_9_1_TemperatureSensorMounting
  "part a) Plot the temperature distribution to identify the measurement error"
  import TRANSFORM;
  extends Icons.Example;
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_w(T=
        293.15) "wall temperature"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Utilities.CharacteristicNumbers.Models.BiotNumber biotNumber(
    L=0.5*D.y,
    lambda=10,
    alpha=2000*L.y^0.8)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Constant D(each k=0.0005) "RTD diameter"
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  Modelica.Blocks.Sources.Constant lambda(each k=50) "thermal conductivity"
    annotation (Placement(transformation(extent={{-80,84},{-72,92}})));
  Modelica.Blocks.Sources.RealExpression alphas[nNodes_1.k](y=2000*RTD.geometry.cs_1
         .^ 0.8) "heat transfer coefficient to fluid"
    annotation (Placement(transformation(extent={{-74,54},{-62,64}})));
  DiscritizedModels.Conduction_1D RTD(
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_10_d_7990_cp_500,
    exposeState_a1=false,
    exposeState_b1=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_1D_z (
        nZ=nNodes_1.k,
        r_outer=0.5*D.y,
        length_z=L.y))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant L(each k=0.05) "RTD length"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=100)
    annotation (Placement(transformation(extent={{-60,84},{-52,92}})));
  Resistances.Heat.Convection convectiontip(alpha=alphas[end].y, surfaceArea=
        RTD.geometry.crossAreas_1[end])
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_infinity(
      T=278.15) "liquid temperature"
    annotation (Placement(transformation(extent={{66,-10},{46,10}})));
  Resistances.Heat.Convection edgeConv[nNodes_1.k](alpha=alphas.y, surfaceArea=
        RTD.geometry.surfaceAreas_23) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-8,-28})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_infinity1[
     nNodes_1.k](each T=278.15) "liquid temperature" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-8,-56})));
  UserInteraction.Outputs.SpatialPlot TemperaturePosition(
    minX=0,
    x=xval,
    y=yval,
    maxX=0.05,
    minY=4,
    maxY=20)  "X - Dimensionless position (-) | T - Temperature (C)"
    annotation (Placement(transformation(extent={{16,-76},{58,-36}})));
  Real xval[nNodes_1.k] = RTD.geometry.cs_1;
  Real yval[nNodes_1.k]=
      TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(RTD.materials.T);
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow ohmicHeating(
      Q_flow=0.0025)
    annotation (Placement(transformation(extent={{-14,30},{6,50}})));
  Utilities.Visualizers.displayReal display(val=yval[end] - 5)
    annotation (Placement(transformation(extent={{68,-66},{88,-46}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=3, x={yval[1],yval[50],
        yval[end]})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(convectiontip.port_b, T_infinity.port)
    annotation (Line(points={{37,0},{37,0},{46,0}},
                                             color={191,0,0}));
  connect(RTD.port_b1, convectiontip.port_a)
    annotation (Line(points={{10,0},{23,0}}, color={191,0,0}));
  connect(T_w.port, RTD.port_a1)
    annotation (Line(points={{-20,0},{-10,0}}, color={191,0,0}));
  connect(RTD.port_external, edgeConv.port_a) annotation (Line(points={{-8,-8},
          {-8,-21},{-8,-21}},     color={191,0,0}));
  connect(T_infinity1.port, edgeConv.port_b) annotation (Line(points={{-8,-46},
          {-8,-35}},               color={191,0,0}));
  connect(ohmicHeating.port, convectiontip.port_a) annotation (Line(
        points={{6,40},{14,40},{14,0},{23,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{62,-42},{94,-52}},
          lineColor={0,0,0},
          textString="Measurement Error (°C)")}),
    experiment(__Dymola_NumberOfIntervals=100, __Dymola_Algorithm="Dassl"));
end Example_1_9_1_TemperatureSensorMounting;
