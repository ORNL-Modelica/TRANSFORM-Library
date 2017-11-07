within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein;
model Example_1_5_1_ThermalProtectionSystem
  "part a) Determine heat flus to air and the rate the the ablative shield is consumed"
  import TRANSFORM;
  extends Icons.Example;

  parameter SI.Length shield_th0 = 0.05 "Initial shield thickness";
  parameter SI.SpecificEnthalpy delta_i_fusion = 200e3 "Heat of fusion";
  parameter SI.Density shield_d = 1200 "Shield density";

  DiscritizedModels.Conduction_1D shield(
    exposeState_b1=true,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_1D
        (
        length_y=1,
        length_z=1,
        nX=10,
        length_x=shield_th),
    exposeState_a1=false,
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_0_33_d_1200_cp_500,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                                                             annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={16,0})));
  DiscritizedModels.Conduction_1D steel(
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_1D
        (
        length_x=0.01,
        length_y=1,
        length_z=1,
        nX=2),
    exposeState_b1=true,
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_20_d_7990_cp_500,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                                                           annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-14,0})));
  Resistances.Heat.Convection convection(alpha=10, surfaceArea=steel.geometry.crossAreas_1
        [1]) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-46,0})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature air(T(
        displayUnit="K") = 320) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-74,0})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow hot(use_port=
        true) annotation (Placement(transformation(extent={{60,-10},{40,10}})));

    SI.Length shield_th;
    SI.ThermalConductivity lambdas[shield.geometry.nX];
  Utilities.Visualizers.DynamicGraph graph(
    Unit="K",
    y_min=275,
    y_max=800,
    t_end=12,
    y_var=shield.materials[1].T,
    y_name="Steel.port_a.T")
    annotation (Placement(transformation(extent={{-30,-92},{28,-38}})));

  Modelica.Blocks.Sources.RealExpression Q_flow(y=100*100^2*shield.geometry.crossAreas_1
        [end]) annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={shield.materials[
        1].T}) annotation (Placement(transformation(extent={{80,80},{100,100}})));
algorithm
  for i in 1:shield.geometry.nX loop
  lambdas[i] :=5.853e-9*(shield.materials[i].T)^3 - 8.4969e-6*(shield.materials[i].T)
      ^2 + 4.5479e-3*(shield.materials[i].T) - 6.5339e-1;
  end for;

initial equation
  shield_th = shield_th0;
equation
  der(shield_th) = (hot.port.Q_flow/shield.geometry.crossAreas_1[end] - air.port.Q_flow/steel.geometry.crossAreas_1[1])/(shield_d*delta_i_fusion);
  connect(convection.port_a, steel.port_a1)
    annotation (Line(points={{-39,0},{-39,0},{-24,0}}, color={191,0,0}));
  connect(air.port, convection.port_b)
    annotation (Line(points={{-64,0},{-64,0},{-53,0}}, color={191,0,0}));
  connect(steel.port_b1, shield.port_a1)
    annotation (Line(points={{-4,0},{1,0},{6,0}}, color={191,0,0}));
  connect(shield.port_b1, hot.port)
    annotation (Line(points={{26,0},{33,0},{40,0}}, color={191,0,0}));
  connect(Q_flow.y, hot.Q_flow_ext)
    annotation (Line(points={{59,0},{54,0}}, color={0,0,127}));
  annotation (                          experiment(StopTime=11.9),
                                         Diagram(graphics={Text(
          extent={{-42,-96},{40,-98}},
          lineColor={28,108,200},
          textString="Plot of temperature nearest steel as a function of time")}));
end Example_1_5_1_ThermalProtectionSystem;
