within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ModelicaMethod.Examples;
model Winding_123D
  import TRANSFORM;
  extends Modelica.Icons.Example;

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ModelicaMethod.Conduction_123D
    winding(
    use_dim3=true,
    exposeState_a1=true,
    exposeState_a3=true,
    exposeState_b3=true,
    exposeState_b1=false,
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_28_5_d_7990_cp_500,
    T_a1_start(displayUnit="K") = 320,
    T_a2_start(displayUnit="K") = 320,
    T_a3_start(displayUnit="K") = 320,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_3D
        (
        r_inner=0.01,
        r_outer=0.02,
        length_z=0.03,
        nR=nNodes_1.k,
        nTheta=nNodes_2.k,
        nZ=nNodes_3.k))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=6)
    annotation (Placement(transformation(extent={{-98,88},{-90,96}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_2(k=3)
    annotation (Placement(transformation(extent={{-84,88},{-76,96}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_3(k=5)
    annotation (Placement(transformation(extent={{-68,88},{-60,96}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_inf_inner[nNodes_2.k,
    nNodes_3.k](each T=320)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic bound_bottom[
    nNodes_1.k,nNodes_2.k] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=45,
        origin={-36,-36})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_inf[nNodes_1.k,
    nNodes_2.k](each T=320)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=45,
        origin={50,50})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection_inner[nNodes_2.k,
    nNodes_3.k] annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-40,0})));
  Modelica.Blocks.Sources.RealExpression hA_inner[nNodes_2.k,nNodes_3.k](y=
        hA_val_inner)
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection_top[nNodes_1.k,
    nNodes_2.k] annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=45,
        origin={28,28})));
  Modelica.Blocks.Sources.RealExpression hA_top[nNodes_1.k,nNodes_2.k](y=
        hA_val_top)
    annotation (Placement(transformation(extent={{70,11},{50,31}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic bound_outer[
    nNodes_2.k,nNodes_3.k]
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));

  Real hA_val_inner[nNodes_2.k,nNodes_3.k];
  Real hA_val_top[nNodes_1.k,nNodes_2.k];
  Modelica.Blocks.Sources.RealExpression Vs[nNodes_1.k,nNodes_2.k,nNodes_3.k](
     y=winding.geometry.Vs)
    annotation (Placement(transformation(extent={{-56,38},{-40,50}})));
  Modelica.Blocks.Sources.RealExpression q_ppp[nNodes_1.k,nNodes_2.k,
    nNodes_3.k](each y=6e5)
    annotation (Placement(transformation(extent={{-56,30},{-40,42}})));
  Modelica.Blocks.Math.Product Q_gen[nNodes_1.k,nNodes_2.k,nNodes_3.k]
    annotation (Placement(transformation(extent={{-30,38},{-22,46}})));
  Utilities.Visualizers.displayReal display(use_port=true)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Blocks.Sources.RealExpression T_max(y=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(max(winding.unitCell.T)))
    annotation (Placement(transformation(extent={{-38,-66},{-22,-54}})));
equation

for j in 1:nNodes_2.k loop
  for k in 1:nNodes_3.k loop
    hA_val_inner[j,k] = 400*winding.geometry.crossAreas_1[1, j, k];
  end for;
end for;

for i in 1:nNodes_1.k loop
  for j in 1:nNodes_2.k loop
    hA_val_top[i,j] = 400*winding.geometry.crossAreas_3[i, j, nNodes_3.k];
  end for;
end for;

  connect(hA_inner.y, convection_inner.Gc)
    annotation (Line(points={{-49,20},{-40,20},{-40,10}}, color={0,0,127}));
  connect(T_inf_inner.port, convection_inner.fluid)
    annotation (Line(points={{-60,0},{-55,0},{-50,0}}, color={191,0,0}));
  connect(convection_inner.solid, winding.port_a1)
    annotation (Line(points={{-30,0},{-20,0},{-10,0}}, color={191,0,0}));
  connect(convection_top.fluid, T_inf.port) annotation (Line(points={{35.0711,
          35.0711},{42.9289,42.9289}},
                              color={191,0,0}));
  connect(bound_bottom.port, winding.port_a3)
    annotation (Line(points={{-28.9289,-28.9289},{-8,-8}}, color={191,0,0}));
  connect(winding.port_b1, bound_outer.port)
    annotation (Line(points={{10,0},{25,0},{40,0}}, color={191,0,0}));
  connect(winding.port_b3, convection_top.solid)
    annotation (Line(points={{8,8},{20.9289,20.9289}}, color={191,0,0}));
  connect(hA_top.y, convection_top.Gc) annotation (Line(points={{49,21},{42.5,
          21},{42.5,20.9289},{35.0711,20.9289}},
                                             color={0,0,127}));
  connect(q_ppp.y, Q_gen.u2) annotation (Line(points={{-39.2,36},{-38,36},{
          -38,39.6},{-30.8,39.6}}, color={0,0,127}));
  connect(Vs.y, Q_gen.u1) annotation (Line(points={{-39.2,44},{-30.8,44},{
          -30.8,44.4}}, color={0,0,127}));
  connect(Q_gen.y, winding.Q_gen) annotation (Line(points={{-21.6,42},{-16,42},
          {-16,5},{-11,5}},     color={0,0,127}));
  connect(T_max.y, display.u)
    annotation (Line(points={{-21.2,-60},{-11.5,-60}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=100, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput);
end Winding_123D;
