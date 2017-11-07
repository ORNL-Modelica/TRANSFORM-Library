within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ModelicaMethod.Examples;
model Winding_12D
  import TRANSFORM;
  extends Modelica.Icons.Example;

  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ModelicaMethod.Conduction_12D
    winding(
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_28_5_d_7990_cp_500,
    use_dim2=true,
    T_a1_start(displayUnit="K") = 320,
    T_a2_start(displayUnit="K") = 320,
    exposeState_a1=false,
    exposeState_b1=true,
    exposeState_a2=true,
    exposeState_b2=false,
    nParallel=2,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_2D_r_z
        (
        nR=nNodes_1.k,
        nZ=nNodes_2.k,
        r_inner=0.01,
        r_outer=0.02,
        length_z=0.03))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=5)
    annotation (Placement(transformation(extent={{-98,88},{-90,96}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_2(k=10)
    annotation (Placement(transformation(extent={{-84,88},{-76,96}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_inf_inner[nNodes_2.k](
     each T=320)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic bound_bottom[
    nNodes_1.k] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-30})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_inf[nNodes_1.k](
      each T=320) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,56})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection_inner[nNodes_2.k]
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-40,0})));
  Modelica.Blocks.Sources.RealExpression hA_inner[nNodes_2.k](y=hA_val_inner)
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection_top[nNodes_1.k]
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={0,28})));
  Modelica.Blocks.Sources.RealExpression hA_top[nNodes_1.k](y=hA_val_top)
    annotation (Placement(transformation(extent={{44,18},{24,38}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic bound_outer[
    nNodes_2.k]
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));

  Real hA_val_inner[nNodes_2.k];
  Real hA_val_top[nNodes_1.k];
  Modelica.Blocks.Sources.RealExpression Vs[nNodes_1.k,nNodes_2.k](y=winding.geometry.Vs)
    annotation (Placement(transformation(extent={{-56,38},{-40,50}})));
  Modelica.Blocks.Sources.RealExpression q_ppp[nNodes_1.k,nNodes_2.k](each y=6e5)
    annotation (Placement(transformation(extent={{-56,30},{-40,42}})));
  Modelica.Blocks.Math.Product Q_gen[nNodes_1.k,nNodes_2.k]
    annotation (Placement(transformation(extent={{-30,38},{-22,46}})));
  Utilities.Visualizers.displayReal display(use_port=true)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Blocks.Sources.RealExpression T_max(y=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(max(winding.unitCell.T)))
    annotation (Placement(transformation(extent={{-38,-66},{-22,-54}})));

     Real xval[nNodes_1.k] = abs(winding.geometry.cs_1[:, 1]);
  Real yval[nNodes_1.k]=
      TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(winding.unitCell[
      :, 1].T);
 Real xval2[nNodes_1.k] = abs(winding.geometry.cs_1[:, nNodes_2.k]);
  Real yval2[nNodes_1.k]=
      TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(winding.unitCell[
      :, nNodes_2.k].T);
equation

  for j in 1:nNodes_2.k loop
    hA_val_inner[j] = 400*winding.geometry.crossAreas_1[1, j];
  end for;

  for i in 1:nNodes_1.k loop
    hA_val_top[i] = 400*winding.geometry.crossAreas_2[i, nNodes_2.k];
  end for;

  connect(T_max.y, display.u)
    annotation (Line(points={{-21.2,-60},{-11.5,-60}}, color={0,0,127}));
  connect(Vs.y, Q_gen.u1) annotation (Line(points={{-39.2,44},{-30.8,44},{-30.8,
          44.4}}, color={0,0,127}));
  connect(q_ppp.y, Q_gen.u2) annotation (Line(points={{-39.2,36},{-36,36},{-36,39.6},
          {-30.8,39.6}}, color={0,0,127}));
  connect(hA_inner.y, convection_inner.Gc)
    annotation (Line(points={{-49,20},{-40,20},{-40,10}}, color={0,0,127}));
  connect(T_inf_inner.port, convection_inner.fluid)
    annotation (Line(points={{-60,0},{-55,0},{-50,0}}, color={191,0,0}));
  connect(convection_inner.solid, winding.port_a1) annotation (Line(points={{-30,
          -1.33227e-015},{-20,-1.33227e-015},{-20,0},{-10,0}}, color={191,0,0}));
  connect(Q_gen.y, winding.Q_gen) annotation (Line(points={{-21.6,42},{-20,42},
          {-20,5},{-11,5}},color={0,0,127}));
  connect(convection_top.solid, winding.port_b2)
    annotation (Line(points={{0,18},{0,14},{0,10}}, color={191,0,0}));
  connect(bound_outer.port, winding.port_b1)
    annotation (Line(points={{40,0},{10,0}},        color={191,0,0}));
  connect(winding.port_a2, bound_bottom.port)
    annotation (Line(points={{0,-10},{0,-15},{0,-20}}, color={191,0,0}));
  connect(hA_top.y, convection_top.Gc)
    annotation (Line(points={{23,28},{10,28},{10,28}}, color={0,0,127}));
  connect(T_inf.port, convection_top.fluid)
    annotation (Line(points={{0,46},{0,38},{0,38}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=100, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput);
end Winding_12D;
