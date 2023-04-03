within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein;
model Example_1_9_2_CryogenicCurrentLeads
  "part a) Find the optimal lead diameter to the cryogenic device"
  import TRANSFORM;
  extends Icons.Example;
  Modelica.Blocks.Sources.Constant D(k=0.004) "lead diameter 0.004 to 0.006"
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  Modelica.Blocks.Sources.Constant L(each k=1) "lead length"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=100)
    annotation (Placement(transformation(extent={{-60,84},{-52,92}})));
  Real xval[nNodes_1.k]=lead.geometry.cs_1;
  Real yval[nNodes_1.k]=lead.materials.T;
  DiscritizedModels.Conduction_1D lead(
    redeclare package Material =
        TRANSFORM.Media.Solids.Copper.OFHC_RRR200,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_1D_z (
        nZ=nNodes_1.k,
        r_outer=0.5*D.y,
        length_z=L.y),
    exposeState_a1=false,
    T_b1_start(displayUnit="K") = 50,
    redeclare model InternalHeatModel =
        DiscritizedModels.BaseClasses.Dimensions_1.OhmicHeatGeneration (I=100),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    T_a1_start=293.15)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_H(T=
        293.15) "room temperature wall"
    annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_C(T(
        displayUnit="K") = 50) "cold vacuum vessel temperature"
    annotation (Placement(transformation(extent={{46,-10},{26,10}})));
  Resistances.Heat.Radiation radiation[nNodes_1.k](surfaceArea=lead.geometry.surfaceAreas_23,
      each epsilon=epsilon.y) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-30})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T__H1[
    nNodes_1.k](each T=T_H.T) "room temperature wall"
    annotation (Placement(transformation(extent={{-46,-56},{-26,-36}})));
  Modelica.Blocks.Sources.Constant epsilon(each k=0.5) "material emissivity"
    annotation (Placement(transformation(extent={{-82,70},{-74,78}})));
  TRANSFORM.Utilities.Visualizers.Outputs.SpatialPlot TemperaturePosition(
    minX=0,
    x=xval,
    y=yval,
    maxX=1,
    minY=50,
    maxY=500) "X - Position m-) | T - Temperature (K)" annotation (Placement(transformation(extent={{-20,22},{22,62}})));
  Utilities.Visualizers.displayReal display(val=D.y*1000)
    annotation (Placement(transformation(extent={{-10,58},{10,78}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={T_C.port.Q_flow})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(T_H.port, lead.port_a1) annotation (Line(
      points={{-26,0},{-18,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.Bezier));
  connect(lead.port_b1, T_C.port) annotation (Line(
      points={{10,0},{18,0},{26,0}},
      color={191,0,0},
      smooth=Smooth.Bezier));
  connect(T__H1.port, radiation.port_b)
    annotation (Line(points={{-26,-46},{-10,-46},{-10,-37}}, color={191,0,0}));
  connect(radiation.port_a, lead.port_external)
    annotation (Line(points={{-10,-23},{-10,-8},{-8,-8}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-12,80},{14,74}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Diameter [mm]")}),
    experiment(
      StopTime=10,
      __Dymola_NumberOfIntervals=1000,
      __Dymola_Algorithm="Dassl"));
end Example_1_9_2_CryogenicCurrentLeads;
