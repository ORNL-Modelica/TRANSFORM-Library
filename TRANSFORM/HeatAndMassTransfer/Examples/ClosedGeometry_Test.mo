within TRANSFORM.HeatAndMassTransfer.Examples;
model ClosedGeometry_Test
  extends TRANSFORM.Icons.Example;
  SI.Temperature Ts_1D[conduction_1D.geometry.nTheta]=conduction_1D.materials.T;
  SI.Temperature Ts_2D[conduction_2D.geometry.nTheta]=conduction_2D.materials[1,:].T;
  SI.Temperature Ts_3D[conduction_3D.geometry.nTheta]=conduction_3D.materials[1,:,1].T;
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.Conduction_2D conduction_2D(
    redeclare model InternalHeatModel =
        TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_2.GenericHeatGeneration
        (Q_gens={{if i == 1 and j == 1 then 100 else 0 for j in 1:conduction_2D.geometry.nTheta}
            for i in 1:conduction_2D.geometry.nR}),
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_2D_r_theta
        (
        nTheta=8,
        r_inner=0.005,
        r_outer=0.01),
    redeclare package Material = TRANSFORM.Media.Solids.UO2)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    adiabatic(nPorts=conduction_2D.geometry.nTheta)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic_multi
    adiabatic1(nPorts=conduction_2D.geometry.nTheta)
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.Conduction_1D conduction_1D(
    redeclare model InternalHeatModel =
        TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_1.GenericHeatGeneration
        (Q_gens={if i == 1 then 100 else 0 for i in 1:conduction_1D.geometry.nTheta}),
    redeclare package Material = TRANSFORM.Media.Solids.UO2,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_1D_theta
        (
        r_inner=0.005,
        r_outer=0.01,
        nTheta=8))
    annotation (Placement(transformation(extent={{-10,42},{10,62}})));
  TRANSFORM.HeatAndMassTransfer.DiscritizedModels.Conduction_3D conduction_3D(
    redeclare package Material = TRANSFORM.Media.Solids.UO2,
    redeclare model Geometry =
        TRANSFORM.HeatAndMassTransfer.ClosureRelations.Geometry.Models.Cylinder_3D
        (
        nTheta=8,
        r_inner=0.005,
        r_outer=0.01),
    redeclare model InternalHeatModel =
        TRANSFORM.HeatAndMassTransfer.DiscritizedModels.BaseClasses.Dimensions_3.GenericHeatGeneration
        (Q_gens={{{if i == 1 and j == 1 and k == 1 then 100 else 0 for k in 1:
            conduction_3D.geometry.nZ} for j in 1:conduction_2D.geometry.nTheta}
            for i in 1:conduction_2D.geometry.nR}))
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic adiabatic2[
    conduction_3D.geometry.nTheta,conduction_3D.geometry.nZ]
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic adiabatic3[
    conduction_3D.geometry.nTheta,conduction_3D.geometry.nZ]
    annotation (Placement(transformation(extent={{40,-60},{20,-40}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic adiabatic4[
    conduction_3D.geometry.nR,conduction_3D.geometry.nTheta]
    annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic adiabatic5[
    conduction_3D.geometry.nR,conduction_3D.geometry.nTheta]
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Utilities.ErrorAnalysis.UnitTests unitTests(n=24, x=cat(
        1,
        Ts_1D,
        Ts_2D,
        Ts_3D))
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(adiabatic.port, conduction_2D.port_a1)
    annotation (Line(points={{-20,0},{-10,0}}, color={191,0,0}));
  connect(conduction_2D.port_b1, adiabatic1.port)
    annotation (Line(points={{10,0},{20,0}}, color={191,0,0}));
  connect(conduction_2D.port_a2, conduction_2D.port_b2) annotation (Line(points={{0,-10},
          {0,-20},{-2,-20},{-2,18},{0,18},{0,10}},                     color={191,
          0,0}));
  connect(conduction_1D.port_a1, conduction_1D.port_b1) annotation (Line(points={{-10,52},
          {-16,52},{-16,40},{16,40},{16,52},{10,52}},         color={191,0,0}));
  connect(adiabatic2.port, conduction_3D.port_a1)
    annotation (Line(points={{-20,-50},{-10,-50}}, color={191,0,0}));
  connect(conduction_3D.port_b1, adiabatic3.port)
    annotation (Line(points={{10,-50},{20,-50}}, color={191,0,0}));
  connect(adiabatic5.port, conduction_3D.port_a3) annotation (Line(points={{-20,-70},
          {-14,-70},{-14,-58},{-8,-58}},      color={191,0,0}));
  connect(adiabatic4.port, conduction_3D.port_b3) annotation (Line(points={{20,-30},
          {14,-30},{14,-42},{8,-42}}, color={191,0,0}));
  connect(conduction_3D.port_b2, conduction_3D.port_a2) annotation (Line(points=
         {{0,-40},{0,-36},{-4,-36},{-4,-64},{0,-64},{0,-60}}, color={191,0,0}));
  annotation (                              experiment(StopTime=100));
end ClosedGeometry_Test;
