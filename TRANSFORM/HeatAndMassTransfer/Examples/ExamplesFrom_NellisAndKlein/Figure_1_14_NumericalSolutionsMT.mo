within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein;
model Figure_1_14_NumericalSolutionsMT
  "Figure 1 - 14 for an aluminnum oxide cylinder  pp. 45-55"
  import TRANSFORM;
  extends Icons.Example;
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_inf_out(T(
        displayUnit="degC") = 373.15)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  DiscritizedModels.HMTransfer_1D cylinder(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_1D_r
        (
        nR=nNodes_1.k,
        r_inner=r_in.y,
        r_outer=r_out.y,
        length_z=1),
    exposeState_a1=false,
    exposeState_b1=false,
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_9_d_7990_cp_500,
    redeclare model InternalHeatModel =
        DiscritizedModels.BaseClasses.Dimensions_1.VolumetricHeatGeneration (
          q_ppps={1e4 + 2e5*cylinder.geometry.rs[i] + 5e7*cylinder.geometry.rs[
            i]^2 for i in 1:nNodes_1.k}),
    nC=2,
    traceDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare model DiffusionCoeff =
        TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.GenericCoefficient
        (D_abs0={1e-2,1e-5}))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=20)
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  Modelica.Blocks.Sources.Constant r_out(each k=0.2) "radius outer"
    annotation (Placement(transformation(extent={{-100,54},{-92,62}})));
  Resistances.Heat.Convection h_out(alpha=200, surfaceArea=cylinder.geometry.crossAreas_1
        [end]) annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Resistances.Heat.Convection h_in(alpha=100, surfaceArea=cylinder.geometry.crossAreas_1
        [1]) annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_inf_in(T(
        displayUnit="degC") = 293.15)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Sources.Constant r_in(each k=0.1) "inner radius"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  UserInteraction.Outputs.SpatialPlot CylinderTemperature(
    minX=0.1,
    maxX=0.2,
    minY=450,
    maxY=675,
    x=cat(
        1,
        {r_in.y},
        cylinder.geometry.rs,
        {r_out.y}),
    y=TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(cat(
        1,
        {h_in.port_a.T},
        cylinder.materials.T,
        {h_out.port_a.T}))) "X - Axial Location (m) | T - Temperature (C)"
    annotation (Placement(transformation(extent={{-24,-72},{30,-18}})));
  Utilities.Visualizers.displayReal display(val=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(max(
        cylinder.materials.T)))
    annotation (Placement(transformation(extent={{-58,-52},{-38,-32}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.Concentration
    high_pressure(
    nC=2,
    C={4.5,4.5},
    use_port=false)
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.Concentration
    low_pressure(
    nC=2,
    C={1.5,1.5},
    use_port=false)
    annotation (Placement(transformation(extent={{90,-30},{70,-10}})));
  UserInteraction.Outputs.SpatialPlot TemperaturePlot(
    minY=0,
    maxY=6,
    x=cat(
        1,
        {r_in.y},
        cylinder.geometry.rs,
        {r_out.y}),
    minX=0.1,
    maxX=0.2,
    y=cat(
        1,
        {high_pressure.C[1]},
        cylinder.Cs[:, 1],
        {low_pressure.C[1]}))
              "X - Axial Location (mm) | C - concentration (mol/m3)"
    annotation (Placement(transformation(extent={{34,-78},{68,-46}})));
  UserInteraction.Outputs.SpatialPlot TemperaturePlot1(
    minY=0,
    maxY=6,
    x=cat(
        1,
        {r_in.y},
        cylinder.geometry.rs,
        {r_out.y}),
    minX=0.1,
    maxX=0.2,
    y=cat(
        1,
        {high_pressure.C[2]},
        cylinder.Cs[:, 2],
        {low_pressure.C[2]}))
              "X - Axial Location (mm) | C - concentration (mol/m3)"
    annotation (Placement(transformation(extent={{68,-78},{102,-46}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=3, x={high_pressure.C[
        1],cylinder.Cs[10, 1],low_pressure.C[1]})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(h_out.port_b, T_inf_out.port)
    annotation (Line(points={{47,0},{70,0}}, color={191,0,0}));
  connect(T_inf_in.port, h_in.port_b)
    annotation (Line(points={{-70,0},{-57,0}}, color={191,0,0}));
  connect(h_in.port_a, cylinder.port_a1)
    annotation (Line(points={{-43,0},{-43,0},{-10,0}}, color={191,0,0}));
  connect(cylinder.port_b1, h_out.port_a)
    annotation (Line(points={{10,0},{33,0}}, color={191,0,0}));
  connect(high_pressure.port, cylinder.portM_a1) annotation (Line(points={{-70,-20},
          {-28,-20},{-28,-4},{-10,-4}},      color={0,140,72}));
  connect(low_pressure.port, cylinder.portM_b1) annotation (Line(points={{70,
          -20},{24,-20},{24,-4},{10,-4}}, color={0,140,72}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Text(
          extent={{-62,-28},{-34,-34}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textString="T_max C")}),
    experiment(__Dymola_NumberOfIntervals=100),
    Documentation(info="<html>
</html>"));
end Figure_1_14_NumericalSolutionsMT;
