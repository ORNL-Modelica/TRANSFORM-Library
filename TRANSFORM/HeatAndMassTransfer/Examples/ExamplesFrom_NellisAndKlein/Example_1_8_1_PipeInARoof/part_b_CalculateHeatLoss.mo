within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein.Example_1_8_1_PipeInARoof;
model part_b_CalculateHeatLoss
  "part a) Determine temperature distribution and heat loss from the pipe"
  import TRANSFORM;
  extends Icons.Example;
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_pipe(T=
        363.15) "hot gas temperature"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.Constant r_p(k=0.05) "pipe radius"
    annotation (Placement(transformation(extent={{-100,84},{-92,92}})));
  Modelica.Blocks.Sources.Constant th(k=0.02)      "beam thickness"
    annotation (Placement(transformation(extent={{-100,70},{-92,78}})));
  Modelica.Blocks.Sources.Constant alpha(k=50)
    "heat transfer coefficient"
    annotation (Placement(transformation(extent={{-72,84},{-64,92}})));
  Modelica.Blocks.Sources.Constant qf_s(k=800) "solar flux"
    annotation (Placement(transformation(extent={{-72,70},{-64,78}})));
  DiscritizedModels.Conduction_1D roof(
    exposeState_a1=false,
    exposeState_b1=true,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_1D_r
        (
        nR=nNodes_1.k,
        r_inner=r_p.y,
        length_z=th.y,
        r_outer=0.5),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_50_d_7990_cp_500)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic adiabatic
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Resistances.Heat.Convection convection[nNodes_1.k](each alpha=alpha.y,
      surfaceArea=roof.geometry.surfaceAreas_3b)
    annotation (Placement(transformation(extent={{-20,-50},{-40,-30}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_infinity[
    nNodes_1.k](each T=293.15) "ambient temperature"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=100)
    annotation (Placement(transformation(extent={{-40,84},{-32,92}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow q_s[nNodes_1.k](
     each use_port=true) "radiation"
    annotation (Placement(transformation(extent={{40,-50},{20,-30}})));
  UserInteraction.Outputs.SpatialPlot TemperaturePosition(
    minX=0,
    x=xval,
    y=yval,
    minY=20,
    maxX=0.5,
    maxY=100) "X - Dimensionless position (-) | T - Temperature (C)"
    annotation (Placement(transformation(extent={{56,-84},{98,-44}})));
 Real xval[nNodes_1.k] = -roof.geometry.cs_1;
  Real yval[nNodes_1.k]=
      TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(roof.materials.T);
  Utilities.Visualizers.displayReal display(precision=0, val=-T_pipe.port.Q_flow)
    annotation (Placement(transformation(extent={{30,68},{50,88}})));
  Modelica.Blocks.Sources.RealExpression Q_flow[nNodes_1.k](y=qf_s.y*roof.geometry.surfaceAreas_3b)
    annotation (Placement(transformation(extent={{60,-50},{40,-30}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={roof.materials[
        1].T}) annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(T_pipe.port, roof.port_a1)
    annotation (Line(points={{-60,0},{-36,0},{-10,0}}, color={191,0,0}));
  connect(roof.port_b1, adiabatic.port)
    annotation (Line(points={{10,0},{60,0}}, color={191,0,0}));
  connect(T_infinity.port, convection.port_b) annotation (Line(points={{-60,-40},
          {-37,-40},{-37,-40}},          color={191,0,0}));
  connect(convection.port_a, roof.port_external) annotation (Line(points={{-23,-40},
          {-8,-40},{-8,-8}},            color={191,0,0}));
  connect(q_s.port, roof.port_external)
    annotation (Line(points={{20,-40},{-8,-40},{-8,-8}}, color={191,0,0}));
  connect(q_s.Q_flow_ext, Q_flow.y)
    annotation (Line(points={{34,-40},{39,-40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{26,90},{58,84}},
          lineColor={0,0,0},
          textString="Heat flow from pipe [W]")}),
    experiment(StopTime=10));
end part_b_CalculateHeatLoss;
