within TRANSFORM.HeatAndMassTransfer.Examples.WindingDiscretizedModels;
model Winding_12D_withMass
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  DiscritizedModels.HMTransfer_2D winding(
    redeclare package Material =
        TRANSFORM.Media.Solids.CustomSolids.Lambda_28_5_d_7990_cp_500,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_2D_r_z (
        nR=nNodes_1.k,
        nZ=nNodes_2.k,
        r_inner=0.01,
        r_outer=0.02,
        length_z=0.03),
    nParallel=2,
    exposeState_a1=true,
    exposeState_b2=true,
    exposeState_b1=true,
    exposeState_a2=true,
    T_a1_start(displayUnit="K") = 320,
    T_a2_start(displayUnit="K") = 320,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare model InternalHeatModel =
        DiscritizedModels.BaseClasses.Dimensions_2.VolumetricHeatGeneration (
          q_ppp=6e5),
    traceDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare model DiffusionCoeff =
        TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.GenericCoefficient (
         D_ab0=1e-6))
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_1(k=5)
    annotation (Placement(transformation(extent={{-98,88},{-90,96}})));
  Modelica.Blocks.Sources.IntegerConstant nNodes_2(k=10)
    annotation (Placement(transformation(extent={{-84,88},{-76,96}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_inf_inner[
    nNodes_2.k](each T=320)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic bound_bottom[
    nNodes_1.k] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-30})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Temperature T_inf[
    nNodes_1.k](each T=320) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,56})));
  Resistances.Heat.Convection convection_inner[nNodes_2.k](each alpha=400,
      surfaceArea=winding.geometry.crossAreas_1[1, :]) annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-40,0})));
  Resistances.Heat.Convection convection_top[nNodes_1.k](each alpha=400,
      surfaceArea=winding.geometry.crossAreas_2[:, end]) annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={0,30})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic bound_outer[
    nNodes_2.k]
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Utilities.Visualizers.displayReal display(use_port=true)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Blocks.Sources.RealExpression T_max(y=
        TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(max(winding.materials.T)))
    annotation (Placement(transformation(extent={{-38,-66},{-22,-54}})));
  UserInteraction.Outputs.SpatialPlot Temperature_y0(
    x=xval,
    y=yval,
    minX=0.01,
    maxX=0.02,
    minY=45,
    maxY=55)
            "X - Axial Location (m) | T - Temperature (C) - Bottom Boundary"
    annotation (Placement(transformation(extent={{16,-76},{58,-36}})));
  UserInteraction.Outputs.SpatialPlot Temperature_y_th_half(
    x=xval2,
    y=yval2,
    minX=0.01,
    maxX=0.02,
    minY=45,
    maxY=55) "X - Axial Location (m) | T - Temperature (C) - Top Boundary"
    annotation (Placement(transformation(extent={{62,-76},{104,-36}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.Concentration
    T_inf_inner1[nNodes_2.k](each C={1})
    annotation (Placement(transformation(extent={{-80,-32},{-60,-12}})));
  Resistances.Mass.Convection convection_inner1[nNodes_2.k](surfaceArea=winding.geometry.crossAreas_1
        [1, :], each alphaM={1000})
                                  annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-40,-22})));
  Resistances.Mass.Convection convection_top1[nNodes_1.k](surfaceArea=winding.geometry.crossAreas_2
        [:, end], each alphaM={1e-3})
                                    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={30,28})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.Concentration T_inf1[
    nNodes_1.k] annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={30,54})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.AdiabaticMass
    bound_outer1[nNodes_2.k]
    annotation (Placement(transformation(extent={{60,-28},{40,-8}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass.AdiabaticMass
    bound_bottom1[nNodes_1.k] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-30})));
  UserInteraction.Outputs.SpatialPlot Concentration_y_th_half(
    minX=0.01,
    maxX=0.02,
    x=mxval2,
    y=myval2,
    minY=0,
    maxY=1)
    "X - Axial Location (m) | C - Concentration (mol/m3) - Top Boundary"
    annotation (Placement(transformation(extent={{-90,-76},{-48,-36}})));
  UserInteraction.Outputs.SpatialPlot Concentration_y(
    minX=0.01,
    maxX=0.02,
    x=mxval,
    y=myval,
    minY=0,
    maxY=1)
    "X - Axial Location (m) | C - Concentration (mol/m3) - Bottom Boundary"
    annotation (Placement(transformation(extent={{-136,-76},{-94,-36}})));
     Real xval[nNodes_1.k] = abs(winding.geometry.cs_1[:, 1]);
  Real yval[nNodes_1.k]=
      TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(winding.materials[
      :, 1].T);
 Real xval2[nNodes_1.k] = abs(winding.geometry.cs_1[:, nNodes_2.k]);
  Real yval2[nNodes_1.k]=
      TRANSFORM.Units.Conversions.Functions.Temperature_K.to_degC(winding.materials[
      :, nNodes_2.k].T);
  Real mxval[nNodes_1.k] = abs(winding.geometry.cs_1[:, 1]);
 Real myval[nNodes_1.k] = winding.Cs[:, 1,1];
 Real mxval2[nNodes_1.k] = abs(winding.geometry.cs_1[:, nNodes_2.k]);
 Real myval2[nNodes_1.k] = winding.Cs[:, nNodes_2.k,1];
  Utilities.Visualizers.displayReal display1(
                                            use_port=true, precision=4)
    annotation (Placement(transformation(extent={{-10,-92},{10,-72}})));
  Modelica.Blocks.Sources.RealExpression C_max(y=max(winding.Cs))
    annotation (Placement(transformation(extent={{-38,-88},{-22,-76}})));
  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=1, x={winding.Cs[2, 3,
        1]}) annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(T_max.y, display.u)
    annotation (Line(points={{-21.2,-60},{-11.5,-60}}, color={0,0,127}));
  connect(T_inf_inner.port, convection_inner.port_b)
    annotation (Line(points={{-60,0},{-47,0}},         color={191,0,0}));
  connect(convection_inner.port_a, winding.port_a1) annotation (Line(points={{-33,
          -1.33227e-015},{-20,-1.33227e-015},{-20,0},{-10,0}}, color={191,0,0}));
  connect(convection_top.port_a, winding.port_b2)
    annotation (Line(points={{0,23},{0,23},{0,10}}, color={191,0,0}));
  connect(bound_outer.port, winding.port_b1)
    annotation (Line(points={{40,0},{10,0}},        color={191,0,0}));
  connect(winding.port_a2, bound_bottom.port)
    annotation (Line(points={{0,-10},{0,-15},{0,-20}}, color={191,0,0}));
  connect(T_inf.port, convection_top.port_b)
    annotation (Line(points={{0,46},{0,37}}, color={191,0,0}));
  connect(T_inf1.port, convection_top1.port_b)
    annotation (Line(points={{30,44},{30,35}},         color={0,140,72}));
  connect(convection_top1.port_a, winding.portM_b2) annotation (Line(points={{30,
          21},{30,16},{4,16},{4,10}}, color={0,140,72}));
  connect(bound_outer1.port, winding.portM_b1) annotation (Line(points={{40,-18},
          {32,-18},{32,-4},{10,-4}}, color={0,140,72}));
  connect(bound_bottom1.port, winding.portM_a2)
    annotation (Line(points={{20,-20},{20,-9.8},{4,-9.8}}, color={0,140,72}));
  connect(T_inf_inner1.port, convection_inner1.port_b) annotation (Line(points={{-60,-22},
          {-47,-22}},                     color={0,140,72}));
  connect(convection_inner1.port_a, winding.portM_a1) annotation (Line(points={{
          -33,-22},{-26,-22},{-20,-22},{-20,-4},{-10,-4}}, color={0,140,72}));
  connect(C_max.y, display1.u)
    annotation (Line(points={{-21.2,-82},{-11.5,-82}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=100, __Dymola_NumberOfIntervals=100));
end Winding_12D_withMass;
