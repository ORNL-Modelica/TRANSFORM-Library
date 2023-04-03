within TRANSFORM.Fluid.FittingsAndResistances.Examples;
model Buoyancy_Test
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
package Medium = Modelica.Media.IdealGases.SingleGases.He;
  TRANSFORM.Fluid.FittingsAndResistances.Buoyancy_specifyFriction
    userSpecified_f(
    f=0.0379830506,
    dimension=dim.k,
    length=len.k,
    angle=ang.k,
    redeclare package Medium = Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,0})));
  BoundaryConditions.Boundary_pT sink(
    T=773.15,
    nPorts=4,
    redeclare package Medium = Medium,
    p=100000) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,70})));
  BoundaryConditions.Boundary_pT source(
    T=873.15,
    nPorts=4,
    redeclare package Medium = Medium,
    p=100000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-70})));
  TRANSFORM.Fluid.FittingsAndResistances.PipeLoss pipeLoss(
                                                         redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.PipeLossResistance.Circle (
        dimension_avg=dim.k,
        dlength=len.k,
        angle=ang.k), redeclare package Medium = Medium)
                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,0})));
  TRANSFORM.Fluid.FittingsAndResistances.Buoyancy_withFriction autoCalculated_f(
    m_flow_start=0.001,
    dimension=dim.k,
    length=len.k,
    angle=ang.k,
    redeclare package Medium = Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,0})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe(
    exposeState_a=false,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        nV=2,
        dimension=dim.k,
        length=len.k,
        angle=ang.k),
    redeclare package Medium = Medium,
    T_a_start=773.15,
    redeclare model InternalHeatGen =
        TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration (
         Q_gens={100,0}))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,0})));
  Modelica.Blocks.Sources.Constant ang(k=0.5*Modelica.Constants.pi)
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Modelica.Blocks.Sources.Constant dim(k=0.5)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.Constant len(k=1.0)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
equation
  connect(userSpecified_f.port_b, sink.ports[1]) annotation (Line(points={{-60,10},
          {-60,40},{-3,40},{-3,60}}, color={0,127,255}));
  connect(autoCalculated_f.port_b, sink.ports[2]) annotation (Line(points={{-20,10},
          {-20,30},{-1,30},{-1,60}},     color={0,127,255}));
  connect(pipeLoss.port_b, sink.ports[3]) annotation (Line(points={{20,10},{20,30},
          {1,30},{1,60}}, color={0,127,255}));
  connect(pipe.port_b, sink.ports[4]) annotation (Line(points={{60,10},{60,40},{
          3,40},{3,60}}, color={0,127,255}));
  connect(userSpecified_f.port_a, source.ports[1]) annotation (Line(points={{-60,-10},
          {-60,-40},{-3,-40},{-3,-60}},      color={0,127,255}));
  connect(autoCalculated_f.port_a, source.ports[2]) annotation (Line(points={{-20,-10},
          {-20,-30},{-1,-30},{-1,-60}},      color={0,127,255}));
  connect(pipeLoss.port_a, source.ports[3]) annotation (Line(points={{20,-10},{20,
          -30},{1,-30},{1,-60}}, color={0,127,255}));
  connect(pipe.port_a, source.ports[4]) annotation (Line(points={{60,-10},{60,-40},
          {3,-40},{3,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Buoyancy_Test;
