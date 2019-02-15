within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein;
model Example_1_7_2_DrawingAWire
  "part a) Determine temperature distribution in the wire"
  import TRANSFORM;
  extends Icons.Example;
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_w(T=
        293.15) "water temperature"
    annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_draw(T=
        873.15) "draw temperature"
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));
  Utilities.CharacteristicNumbers.Models.BiotNumber biotNumber(
    alpha=alpha.y,
    L=0.5*D.y,
    lambda=230)
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  Modelica.Blocks.Sources.Constant D(each k=0.0005) "wire diameter"
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  Modelica.Blocks.Sources.Constant u(each k=0.01) "draw velocity"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  Modelica.Blocks.Sources.Constant L(each k=0.25) "wire length"
    annotation (Placement(transformation(extent={{-100,56},{-92,64}})));
  Modelica.Blocks.Sources.Constant alpha(each k=25)
    "heat transfer coefficient"
    annotation (Placement(transformation(extent={{-72,84},{-64,92}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_infinity[
    nNodes_1.k](each T=293.15) "ambient temperature"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Resistances.Heat.Convection convection[nNodes_1.k](each alpha=alpha.y,
      surfaceArea=wire.geometry.surfaceAreas_23)
    annotation (Placement(transformation(extent={{-30,0},{-50,20}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=100)
    annotation (Placement(transformation(extent={{-40,84},{-32,92}})));
  DiscritizedModels.Conduction_1D wire(
    exposeState_a1=false,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_1D_z
        (
        nZ=nNodes_1.k,
        r_outer=0.5*D.y,
        length_z=L.y),
    exposeState_b1=false,
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_230_d_2700_cp_1000,
    velocity_1=0.01,
    T_a1_start=873.15,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,0})));
  UserInteraction.Outputs.SpatialPlot TemperaturePosition(
    minX=0,
    x=xval,
    y=yval,
    maxX=1,
    minY=0,
    maxY=700) "X - Dimensionless position (-) | T - Temperature (C)"
    annotation (Placement(transformation(extent={{16,-76},{58,-36}})));
  Real xval[nNodes_1.k] = wire.geometry.cs_1/L.y;
  Real yval[nNodes_1.k]=
      TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(wire.materials.T);
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={yval[90]})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(convection.port_b, T_infinity.port) annotation (Line(points={{-47,10},
          {-47,10},{-70,10}},     color={191,0,0}));
  connect(T_draw.port, wire.port_a1)
    annotation (Line(points={{-10,50},{0,50},{0,10}}, color={191,0,0}));
  connect(T_w.port, wire.port_b1)
    annotation (Line(points={{-10,-50},{0,-50},{0,-10}}, color={191,0,0}));
  connect(convection.port_a, wire.port_external)
    annotation (Line(points={{-33,10},{-8,10},{-8,8}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=50, __Dymola_NumberOfIntervals=100),
    Documentation(info="<html>
<p>Moving boundaries seem to be a problem with the current implementation of the conduction model. Can it be addressed in the current conduction method or does the other &QUOT;classical&QUOT; approach work better?</p>
</html>"));
end Example_1_7_2_DrawingAWire;
