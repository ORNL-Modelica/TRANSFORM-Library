within TRANSFORM.Fluid.Examples.TritiumExamples;
model PbLiTest2
  extends TRANSFORM.Icons.Example;
  package Medium=TRANSFORM.Media.Fluids.PbLi.ConstantPropertyLiquidPbLi(extraPropertiesNames={"Tritium"});
  Modelica.Fluid.Sources.MassFlowSource_T source(
    use_C_in=true,
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=26000,
    T=743.15)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_wWall_wTraceMass
                                             permeator(
    use_HeatTransfer=true,
    use_HeatTransferOuter=true,
    use_TraceMassTransferOuter=true,
    use_TraceMassTransfer=true,
    redeclare package Medium = Medium,
    h_a_start=1.5e6,
    h_b_start=1.5e6,
    use_Ts_start=true,
    redeclare package Material = TRANSFORM.Media.Solids.SS304,
    nb=fill(
        1,
        permeator.nV,
        Medium.nC),
    m_flow_a_start=26000,
    nParallel=19432,
    Ka=fill(
        kL.kSs[1],
        permeator.nV,
        Medium.nC),
    Kb=fill(
        kS.kSs[1],
        permeator.nV,
        Medium.nC),
    redeclare model DiffusionCoeff_wall =
      TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation (
        iTable={15},
        Ea=1.32E+04,
        use_RecordData=false,
        D_ab0=1.00E-07),
    redeclare model Geometry =
      ClosureRelations.Geometry.Models.DistributedVolume_1D.Pipe_Wall.StraightPipe (
        dimension=0.01,
        th_wall=0.0005,
        length=37.3,
        nV=37,
        nR=7),
    p_a_start=100000,
    T_a_start=743.15,
    T_b_start=743.15,
    redeclare model TraceMassTransfer =
        ClosureRelations.MassTransfer.Models.DistributedPipe_TraceMass_1D_MultiTransferSurface.Shs_SinglePhase_2Region (
         MMs=fill(0.006032, permeator.nC), redeclare model DiffusionCoeff =
            TRANSFORM.Media.ClosureModels.MassDiffusionCoefficient.Models.ArrheniusEquation (
            iTable={1},
            use_RecordData=false,
            D_ab0=2.5e-7,
            Ea=27000)),
    T_a1_start=743.15,
    T_a2_start=743.15)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}})));
  Modelica.Fluid.Sources.Boundary_pT sink(
    redeclare package Medium = Medium,
    p=100000,
    T=743.15,
    nPorts=1) annotation (Placement(transformation(extent={{90,-10},{70,10}})));
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
  Modelica.Blocks.Sources.Constant const(k=5.812e-10)
    annotation (Placement(transformation(extent={{-100,-18},{-80,2}})));
  Modelica.Fluid.Sensors.TraceSubstancesTwoPort permeatorIn(
      substanceName="Tritium", redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Fluid.Sensors.TraceSubstancesTwoPort permeatorOut(
      substanceName="Tritium", redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Math.Division CBdivC0 annotation (Placement(transformation(
        extent={{-5,5},{5,-5}},
        rotation=90,
        origin={0,39})));
  TRANSFORM.Media.ClosureModels.SievertsLawCoefficient.Models.ArrheniusEquation
    kS(
    iTable={14},
    deltaH=28600,
    kS0=0.872,
    use_RecordData=false,
    T=743.15)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  TRANSFORM.Media.ClosureModels.SievertsLawCoefficient.Models.ArrheniusEquation
    kL(iTable={1},
    use_RecordData=false,
    kS0=1.26e-3,
    deltaH=1350,
    T=743.15)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Math.Add eta(k1=-1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,70})));
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
  connect(permeatorIn.port_b, permeator.port_a)
    annotation (Line(points={{-20,0},{-15,0},{-10,0}}, color={0,127,255}));
  connect(permeator.port_b, permeatorOut.port_a) annotation (Line(
      points={{10,0},{20,0}},
      color={0,127,255},
      thickness));
  connect(permeatorIn.C, CBdivC0.u2) annotation (Line(points={{-30,11},{-30,20},
          {-3,20},{-3,33}}, color={0,0,127}));
  connect(source.ports[1], permeatorIn.port_a)
    annotation (Line(points={{-50,0},{-50,0},{-40,0}}, color={0,127,255}));
  connect(permeatorOut.port_b, sink.ports[1])
    annotation (Line(points={{40,0},{70,0}},        color={0,127,255}));
  connect(adiabatic.port, permeator.heatPorts) annotation (Line(
      points={{10,-20},{10,-12},{0,-12},{0,-5}},
      color={191,0,0},
      thickness));
  connect(vacuum.port, permeator.massPorts) annotation (Line(
      points={{-10,-20},{-10,-12},{-4,-12},{-4,-5}},
      color={0,140,72},
      thickness));
  connect(CBdivC0.y, eta.u1) annotation (Line(points={{4.44089e-016,44.5},{
          4.44089e-016,52},{4,52},{4,58}}, color={0,0,127}));
  connect(one.y, eta.u2) annotation (Line(points={{20,44.5},{20,52},{16,52},{16,
          58}}, color={0,0,127}));
  connect(permeatorOut.C, CBdivC0.u1)
    annotation (Line(points={{30,11},{30,20},{3,20},{3,33}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100));
end PbLiTest2;
