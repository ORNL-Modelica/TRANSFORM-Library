within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein;
model Example_1_3_2_AbsorptionInALens
  "Part a & b) Determine the temperature distribution in the lense"
  import TRANSFORM;
  extends Icons.Example;

  DiscritizedModels.Conduction_1D lense(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_1D
        (
        nX=nNodes_1.k,
        length_x=L.y,
        length_y=1,
        length_z=1),
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_1_5_d_7990_cp_500,
    exposeState_a1=true,
    exposeState_b1=true,
    redeclare model InternalHeatModel =
        DiscritizedModels.BaseClasses.Dimensions_1.VolumetricHeatGeneration (
          q_ppps={1000*100*Modelica.Math.exp(-100*lense.geometry.xs[i]) for i in
                1:nNodes_1.k}))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant L(each k=0.01) "Length of plane wall"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=20)
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  Resistances.Heat.Convection convection_top(alpha=20, surfaceArea=lense.geometry.crossAreas_1
        [1]) annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
  Resistances.Heat.Convection convection_bottom(alpha=20, surfaceArea=lense.geometry.crossAreas_1
        [end]) annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature Ambient_top(
      T=293.15)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature
    Ambient_bottom(T=293.15)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  UserInteraction.Outputs.SpatialPlot TemperaturePlot(
    x=TRANSFORM.Units.Conversions.Functions.Distance_m.to_mm(lense.geometry.xs),
    maxX=10,
    y=TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(lense.materials.T),
    minY=35.6,
    maxY=36.4) "X - Axial Location (mm) | T - Temperature (C)"
    annotation (Placement(transformation(extent={{-30,-78},{30,-20}})));

  Modelica.Blocks.Sources.RealExpression position(y=
        TRANSFORM.Units.Conversions.Functions.Distance_m.to_cm(lense.geometry.xs[
        Modelica.Math.Vectors.find(
        max(lense.materials.T),
        lense.materials.T,
        0.001)]))
    annotation (Placement(transformation(extent={{-44,70},{-28,82}})));
  Utilities.Visualizers.displayReal display(use_port=true)
    annotation (Placement(transformation(extent={{-20,66},{0,86}})));
  Modelica.Blocks.Sources.RealExpression T_max(y=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(max(lense.materials.T)))
    annotation (Placement(transformation(extent={{-44,56},{-28,68}})));
  Utilities.Visualizers.displayReal display1(use_port=true)
    annotation (Placement(transformation(extent={{-20,52},{0,72}})));

  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={T_max.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(position.y, display.u)
    annotation (Line(points={{-27.2,76},{-21.5,76}}, color={0,0,127}));
  connect(T_max.y, display1.u)
    annotation (Line(points={{-27.2,62},{-21.5,62}}, color={0,0,127}));
  connect(Ambient_top.port, convection_top.port_b)
    annotation (Line(points={{-60,0},{-37,0}}, color={191,0,0}));
  connect(convection_bottom.port_b, Ambient_bottom.port)
    annotation (Line(points={{37,0},{60,0}}, color={191,0,0}));
  connect(lense.port_b1, convection_bottom.port_a)
    annotation (Line(points={{10,0},{23,0}}, color={191,0,0}));
  connect(convection_top.port_a, lense.port_a1)
    annotation (Line(points={{-23,0},{-23,0},{-10,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Text(
          extent={{2,80},{46,70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="mm location of peak temperature"),
                         Text(
          extent={{2,66},{40,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="max T (C) in lense")}),
    experiment(__Dymola_NumberOfIntervals=100),
    Documentation(info="<html>
</html>"));
end Example_1_3_2_AbsorptionInALens;
