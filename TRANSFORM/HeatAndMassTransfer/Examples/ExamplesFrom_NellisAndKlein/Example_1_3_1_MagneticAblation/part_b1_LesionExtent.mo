within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein.Example_1_3_1_MagneticAblation;
model part_b1_LesionExtent
  "Part b) Locate the location where the tissue first reaches the lethal temperature"
  import TRANSFORM;
  extends Icons.Example;
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow Adiabatic(
      Q_flow=0) "Adiabatic boundary condition at sphere center"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  DiscritizedModels.Conduction_1D thermoseed(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Sphere_1D_r
        (                                                                 nR=
            nNodes_1_ts.k, r_outer=r_ts.y),
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_10_d_7990_cp_500,
    redeclare model InternalHeatModel =
        DiscritizedModels.BaseClasses.Dimensions_1.VolumetricHeatGeneration (
          q_ppp=3*Q_gen_ts.y/(4*Modelica.Constants.pi*r_ts.k^3)))
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Modelica.Blocks.Sources.Constant r_ts(each k=0.001)
    "radius of thermoseed"
    annotation (Placement(transformation(extent={{-100,68},{-92,76}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1_ts(k=10)
    annotation (Placement(transformation(extent={{-100,82},{-92,90}})));
  DiscritizedModels.Conduction_1D tissue(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Sphere_1D_r
        (
        nR=nNodes_1_t.k,
        r_inner=r_ts.y,
        r_outer=r_t.y,
        drs=Math.logspace_dx(
            r_ts.y,
            r_t.y,
            nNodes_1_t.k + 1)),
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_0_5_d_7990_cp_500,
    exposeState_b1=false)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1_t(k=100)
    annotation (Placement(transformation(extent={{-86,82},{-78,90}})));
  Modelica.Blocks.Sources.Constant r_t(each k=1)
    "radius of infiinite medium"
    annotation (Placement(transformation(extent={{-100,54},{-92,62}})));
  UserInteraction.Outputs.SpatialPlot TemperaturePlot(
    x=TRANSFORM.Units.Conversions.Functions.Distance_m.to_mm(cat(
        1,
        {0},
        thermoseed.geometry.rs,
        tissue.geometry.rs,
        {r_t.y + r_ts.y})),
    maxY=200,
    minY=50,
    maxX=10,
    y=TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(cat(
        1,
        {Adiabatic.port.T},
        thermoseed.materials.T,
        tissue.materials.T,
        {Tissue_infinite.port.T})))
    "X - Axial Location (mm) | T - Temperature (C)"
    annotation (Placement(transformation(extent={{-26,-82},{28,-28}})));
  Modelica.Blocks.Sources.Constant Q_gen_ts(each k=1)
    annotation (Placement(transformation(extent={{-100,34},{-92,42}})));
  Modelica.Blocks.Sources.Constant T_lethal(k=323.15)
    annotation (Placement(transformation(extent={{-100,20},{-92,28}})));
  Modelica.Blocks.Sources.RealExpression r_lesion(y=
        TRANSFORM.Units.Conversions.Functions.Distance_m.to_mm(tissue.geometry.rs[
        integer(node.y)]))
    annotation (Placement(transformation(extent={{-34,62},{-18,74}})));
  Utilities.Visualizers.displayReal display(use_port=true)
    annotation (Placement(transformation(extent={{-10,58},{10,78}})));
  Modelica.Blocks.Sources.RealExpression T_max(y=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(max(tissue.materials.T)))
    annotation (Placement(transformation(extent={{-34,48},{-18,60}})));
  Utilities.Visualizers.displayReal display1(use_port=true)
    annotation (Placement(transformation(extent={{-10,44},{10,64}})));
  Modelica.Blocks.Sources.RealExpression node(y=Modelica.Math.Vectors.find(
          T_lethal.y,
          tissue.materials.T,
          1))
    annotation (Placement(transformation(extent={{-34,76},{-18,88}})));
  Utilities.Visualizers.displayReal display2(
                                            use_port=true)
    annotation (Placement(transformation(extent={{-10,72},{10,92}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature
    Tissue_infinite(T=310.15)
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=3, x={Adiabatic.port.T,
        thermoseed.materials[3].T,tissue.materials[2].T})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(r_lesion.y, display.u)
    annotation (Line(points={{-17.2,68},{-11.5,68}}, color={0,0,127}));
  connect(T_max.y, display1.u)
    annotation (Line(points={{-17.2,54},{-11.5,54}}, color={0,0,127}));
  connect(node.y, display2.u)
    annotation (Line(points={{-17.2,82},{-11.5,82}}, color={0,0,127}));
  connect(Adiabatic.port, thermoseed.port_a1)
    annotation (Line(points={{-60,0},{-45,0},{-30,0}}, color={191,0,0}));
  connect(thermoseed.port_b1, tissue.port_a1)
    annotation (Line(points={{-10,0},{0,0},{10,0}}, color={191,0,0}));
  connect(tissue.port_b1, Tissue_infinite.port)
    annotation (Line(points={{30,0},{40,0},{50,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Text(
          extent={{12,72},{56,62}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="mm from Thermoseed center
where crosses T = 50C"),Text(
          extent={{12,58},{50,52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="max T (C) in tissue "),
                  Text(
          extent={{12,86},{52,78}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="radial tissue node
where crosses T = 50C")}),
    experiment(__Dymola_NumberOfIntervals=100),
    Documentation(info="<html>
</html>"));
end part_b1_LesionExtent;
