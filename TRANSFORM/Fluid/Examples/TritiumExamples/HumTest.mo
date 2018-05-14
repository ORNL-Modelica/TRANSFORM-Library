within TRANSFORM.Fluid.Examples.TritiumExamples;
model HumTest

  extends TRANSFORM.Icons.Example;

  package Medium =
      TRANSFORM.Media.Fluids.FLiBe.ConstantPropertyLiquidFLiBe (          extraPropertiesNames={"Tritium"});

  Modelica.Fluid.Sources.MassFlowSource_T source(
    use_C_in=true,
    nPorts=1,
    redeclare package Medium = Medium,
    m_flow=2.468,
    T=973.15)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_wWall_wTraceMass
                                             permeator(
    use_HeatTransfer=true,
    use_HeatTransferOuter=true,
    use_TraceMassTransferOuter=true,
    use_TraceMassTransfer=true,
    redeclare package Medium = Medium,
    nb=fill(
        2,
        permeator.nV,
        Medium.nC),
    Ka=fill(
        kH.kHs[1],
        permeator.nV,
        Medium.nC),
    Kb=fill(
        kS.kSs[1],
        permeator.nV,
        Medium.nC),
    nParallel=1,
    use_Ts_start=true,
    m_flow_a_start=2.468,
    redeclare model DiffusionCoeff_wall =
        TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation
        (iTable={10}),
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall.StraightPipe
        (
        dimension=0.0254,
        length=50,
        nV=50,
        nR=7,
        th_wall=0.00025),
    redeclare package Material = Media.Solids.AlloyN,
    redeclare model TraceMassTransfer =
        ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D.Shs_SinglePhase_Overall
        (MMs=fill(0.006032, permeator.nC), redeclare model DiffusionCoeff =
            TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation
            (iTable={1})),
    p_a_start=100000,
    T_a_start=973.15,
    T_b_start=973.15)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}})));

  Modelica.Fluid.Sources.Boundary_pT sink(
    nPorts=1,
    redeclare package Medium = Medium,
    p=100000,
    T=973.15) annotation (Placement(transformation(extent={{90,-10},{70,10}})));

  HeatAndMassTransfer.BoundaryConditions.Heat.Adiabatic adiabatic
                                                                [permeator.nV]
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,-30})));
  HeatAndMassTransfer.BoundaryConditions.Mass.Concentration vacuum
                                                                 [permeator.nV]
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-30})));

  Modelica.Blocks.Sources.Constant const(k=2e6*1.629e-12)
    annotation (Placement(transformation(extent={{-100,-18},{-80,2}})));
  Modelica.Fluid.Sensors.TraceSubstancesTwoPort permeatorIn(
      substanceName="Tritium", redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Fluid.Sensors.TraceSubstancesTwoPort permeatorOut(
      substanceName="Tritium", redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Math.Add      eta(k1=-1)
                                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,70})));
  TRANSFORM.Media.ClosureModels.SievertsLawCoefficient.Models.ArrheniusEquation
    kS(
    kS0=0.953,
    deltaH=10.7e3,
    T=973.15,
    iTable={9}) "kS0=0.953,deltaH= 10.7e3"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  TRANSFORM.Media.ClosureModels.HenrysLawCoefficient.Models.ExponentialTemperature
    kH(iTable={1}, T=973.15)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Math.Division CBdivC0 annotation (Placement(transformation(
        extent={{-5,5},{5,-5}},
        rotation=90,
        origin={0,39})));
  Modelica.Blocks.Sources.Constant one(k=1) annotation (Placement(
        transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={20,39})));
  Utilities.ErrorAnalysis.UnitTests unitTests(printResult=false, x={eta.y})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(const.y, source.C_in[1])
    annotation (Line(points={{-79,-8},{-70,-8}},            color={0,0,127}));
  connect(source.ports[1], permeatorIn.port_a)
    annotation (Line(points={{-50,0},{-45,0},{-40,0}}, color={0,127,255}));
  connect(permeatorIn.port_b, permeator.port_a)
    annotation (Line(points={{-20,0},{-15,0},{-10,0}}, color={0,127,255}));
  connect(permeator.port_b, permeatorOut.port_a) annotation (Line(
      points={{10,0},{15,0},{20,0}},
      color={0,127,255},
      thickness=0.5));
  connect(permeatorOut.port_b, sink.ports[1])
    annotation (Line(points={{40,0},{70,0}}, color={0,127,255}));
  connect(permeatorIn.C, CBdivC0.u2) annotation (Line(points={{-30,11},{-30,20},
          {-3,20},{-3,33}}, color={0,0,127}));
  connect(permeatorOut.C, CBdivC0.u1)
    annotation (Line(points={{30,11},{30,20},{3,20},{3,33}}, color={0,0,127}));
  connect(CBdivC0.y, eta.u1)
    annotation (Line(points={{0,44.5},{0,52},{4,52},{4,58}}, color={0,0,127}));
  connect(eta.u2, one.y) annotation (Line(points={{16,58},{16,52},{20,52},{20,
          44.5}}, color={0,0,127}));
  connect(vacuum.port, permeator.massPorts) annotation (Line(
      points={{-10,-20},{-10,-12},{-4,-12},{-4,-5}},
      color={0,140,72},
      thickness=0.5));
  connect(permeator.heatPorts, adiabatic.port) annotation (Line(
      points={{0,-5},{0,-12},{10,-12},{10,-20}},
      color={191,0,0},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100));
end HumTest;
