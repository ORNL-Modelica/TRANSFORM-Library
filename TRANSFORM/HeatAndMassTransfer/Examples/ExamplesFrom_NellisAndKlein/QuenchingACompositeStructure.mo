within TRANSFORM.HeatAndMassTransfer.Examples.ExamplesFrom_NellisAndKlein;
model QuenchingACompositeStructure
  "Example 3.3-2 Quenching a composite structure pp. 363-369"
  import TRANSFORM;
  extends Icons.Example;

  Modelica.Blocks.Sources.Constant th_s(each k=0.0005) "thickness - silicon"
    annotation (Placement(transformation(extent={{-82,84},{-74,92}})));
  Modelica.Blocks.Sources.Constant lambda_s(each k=150)
    "thermal conductivity - silicon"
    annotation (Placement(transformation(extent={{-68,84},{-60,92}})));
  Modelica.Blocks.Sources.Constant d_s(each k=2300) "density - silicon"
    annotation (Placement(transformation(extent={{-68,70},{-60,78}})));
  Modelica.Blocks.Sources.Constant cp_s(each k=700) "heat capacity - silicon"
    annotation (Placement(transformation(extent={{-68,56},{-60,64}})));
  Modelica.Blocks.Sources.Constant Tini(k=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degC(750))
    "initial temperature"
    annotation (Placement(transformation(extent={{-82,42},{-74,50}})));
  Modelica.Blocks.Sources.Constant Twater(k=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.from_degC(20))
    "water temperature"
    annotation (Placement(transformation(extent={{-96,42},{-88,50}})));
  Modelica.Blocks.Sources.Constant L(k=0.1) "length of laminated structure"
    annotation (Placement(transformation(extent={{-96,84},{-88,92}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=100)
    annotation (Placement(transformation(extent={{-96,56},{-88,64}})));

  Modelica.Blocks.Sources.Constant lambda_p(each k=1.4)
    "thermal conductivity - pyrex"
    annotation (Placement(transformation(extent={{-54,84},{-46,92}})));
  Modelica.Blocks.Sources.Constant d_p(each k=2200) "density - pyrex"
    annotation (Placement(transformation(extent={{-54,70},{-46,78}})));
  Modelica.Blocks.Sources.Constant cp_p(each k=800) "heat capacity - pyrex"
    annotation (Placement(transformation(extent={{-54,56},{-46,64}})));
  Modelica.Blocks.Sources.Constant th_p(each k=0.0005) "thickness - pyrex"
    annotation (Placement(transformation(extent={{-82,70},{-74,78}})));
  Modelica.Blocks.Sources.RealExpression lambda_effective(y=1/(th_s.y/(lambda_s.y
        *(th_s.y + th_p.y)) + th_p.y/(lambda_p.y*(th_s.y + th_p.y))))
    annotation (Placement(transformation(extent={{-40,78},{-20,98}})));
  Utilities.Visualizers.displayReal display_lambda_effective(use_port=true,
      precision=1)
    annotation (Placement(transformation(extent={{-10,78},{10,98}})));
  Modelica.Blocks.Sources.RealExpression d_effective(y=th_s.y/(th_s.y + th_p.y)
        *d_s.y + th_p.y/(th_s.y + th_p.y)*d_p.y)
    annotation (Placement(transformation(extent={{-40,64},{-20,84}})));
  Utilities.Visualizers.displayReal display_d_effective(use_port=true,
      precision=0)
    annotation (Placement(transformation(extent={{-10,64},{10,84}})));
  Modelica.Blocks.Sources.RealExpression cp_effective(y=th_s.y/(th_s.y + th_p.y)
        *d_s.y/d_effective.y*cp_s.y + th_p.y/(th_s.y + th_p.y)*d_p.y/
        d_effective.y*cp_p.y)
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Utilities.Visualizers.displayReal display_cp_effective(use_port=true,
      precision=0)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Utilities.CharacteristicNumbers.Models.DiffusiveHeatTimeConstant tau_diff(
    L=L.y/2,
    d=d_effective.y,
    cp=cp_effective.y,
    lambda=lambda_effective.y)
    "time for thermal wave to reach half-thickness of the bonded structure"
    annotation (Placement(transformation(extent={{-46,30},{-26,50}})));
  Utilities.Visualizers.displayReal display_tau_diff(use_port=true, precision=0)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  DiscritizedModels.Conduction_1D composite(
    exposeState_b1=true,
    T_b1_start=Tini.k,
    exposeState_a1=false,
    T_a1_start=Tini.k,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_2_8_d_2250_cp_749,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_1D
        (                                                              nX=
            nNodes_1.k, length_x=L.y/2))
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature water(
      use_port=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,0})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic adiabatic
    annotation (Placement(transformation(extent={{0,-10},{-20,10}})));
  Utilities.Visualizers.DynamicGraph scope(
    y_min=0,
    y_max=4e4,
    Unit="K/m",
    use_port=true,
    t_end=380)
    annotation (Placement(transformation(extent={{-70,-92},{-12,-38}})));
  Modelica.Blocks.Sources.RealExpression dTdx(y=(composite.materials[20].T -
        composite.materials[19].T)/(composite.geometry.cs_1[20] - composite.geometry.cs_1
        [19]))
    annotation (Placement(transformation(extent={{-100,-64},{-80,-44}})));
  DiscritizedModels.Conduction_1D composite1(
    exposeState_b1=true,
    T_b1_start=Tini.k,
    exposeState_a1=false,
    T_a1_start=Tini.k,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_2_8_d_2250_cp_749,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Plane_1D
        (                                                              nX=
            nNodes_1.k, length_x=L.y/2))
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature gas(
      use_port=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={4,0})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic adiabatic1
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Resistances.Heat.Convection convection(surfaceArea=composite1.geometry.crossAreas_1
        [1], alpha=100)
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
  Utilities.Visualizers.DynamicGraph scope1(
    y_min=0,
    y_max=4e4,
    Unit="K/m",
    t_end=380,
    use_port=true)
    annotation (Placement(transformation(extent={{30,-92},{88,-38}})));
  Modelica.Blocks.Sources.RealExpression dTdx1(y=(composite1.materials[20].T -
        composite1.materials[19].T)/(composite1.geometry.cs_1[20] - composite1.geometry.cs_1
        [19])) annotation (Placement(transformation(extent={{0,-64},{20,-44}})));
  Modelica.Blocks.Sources.RealExpression T_water(y=Twater.y)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={composite.summary.T_effective})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(lambda_effective.y, display_lambda_effective.u)
    annotation (Line(points={{-19,88},{-11.5,88}}, color={0,0,127}));
  connect(d_effective.y, display_d_effective.u)
    annotation (Line(points={{-19,74},{-11.5,74}}, color={0,0,127}));
  connect(cp_effective.y, display_cp_effective.u)
    annotation (Line(points={{-19,60},{-11.5,60}}, color={0,0,127}));
  connect(tau_diff.y, display_tau_diff.u)
    annotation (Line(points={{-25,40},{-11.5,40}}, color={0,0,127}));
  connect(composite.port_b1, adiabatic.port)
    annotation (Line(points={{-30,0},{-25,0},{-20,0}}, color={191,0,0}));
  connect(water.port, composite.port_a1)
    annotation (Line(points={{-60,0},{-55,0},{-50,0}}, color={191,0,0}));
  connect(dTdx.y, scope.u) annotation (Line(points={{-79,-54},{-72.4857,
          -54},{-72.4857,-67.0769}},
                               color={0,0,127}));
  connect(composite1.port_b1, adiabatic1.port)
    annotation (Line(points={{70,0},{70,0},{80,0}}, color={191,0,0}));
  connect(gas.port, convection.port_b)
    annotation (Line(points={{14,0},{23,0}},        color={191,0,0}));
  connect(convection.port_a, composite1.port_a1)
    annotation (Line(points={{37,0},{37,0},{50,0}}, color={191,0,0}));
  connect(dTdx1.y, scope1.u) annotation (Line(points={{21,-54},{27.5143,
          -54},{27.5143,-67.0769}},
                              color={0,0,127}));
  connect(T_water.y, water.T_ext)
    annotation (Line(points={{-79,20},{-79,0},{-74,0}}, color={0,0,127}));
  connect(gas.T_ext, T_water.y)
    annotation (Line(points={{0,0},{-6,0},{-6,20},{-79,20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-66,-26},{-16,-40}},
          lineColor={0,0,0},
          textString="Plot of Temperature gradient per distance at ~1 cm
 demonstrating likely location of failure"), Text(
          extent={{34,-26},{84,-40}},
          lineColor={0,0,0},
          textString="Plot of Temperature gradient per distance at ~1 cm
 demonstrating no failure with lower heat transfer coefficient")}),
    experiment(StopTime=380));
end QuenchingACompositeStructure;
