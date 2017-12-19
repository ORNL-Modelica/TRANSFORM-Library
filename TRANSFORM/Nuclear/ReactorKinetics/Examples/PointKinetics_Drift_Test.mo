within TRANSFORM.Nuclear.ReactorKinetics.Examples;
model PointKinetics_Drift_Test
  extends Modelica.Icons.Example;

  replaceable package Medium =
      TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_pT (
  extraPropertiesNames={"PreGroup_1","PreGroup_2","PreGroup_3","PreGroup_4","PreGroup_5","PreGroup_6"},
  C_nominal={1e6,1e6,1e6,1e6,1e6,1e6});

  parameter SI.Length H = 3.4;
  parameter SI.Length L = 6.296;
  parameter SI.Velocity v=0.4772;
  parameter SI.Length d = sqrt(4*1/1000/v/Modelica.Constants.pi);

  SI.MassFlowRate[pipe1.nV,kinetics.nI] mC_gens2 = {{-kinetics.lambda_i[j]*pipe1.mCs[i, j] for j in 1:kinetics.nI} for i in 1:pipe1.nV};

  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT boundary(nPorts=1, redeclare
      package Medium = Medium,
    p=100000)
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T boundary1(nPorts=1,
      redeclare package Medium = Medium,
    m_flow=1,
    C=fill(1e-6, 6),
    use_C_in=true,
    T=573.15)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe(
    redeclare package Medium = Medium,
    m_flow_a_start=1,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=d,
        length=H,
        nV=10),
    p_a_start=100000,
    T_a_start=573.15,
    T_b_start=773.15,
    redeclare model InternalHeatGen =
        TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
        (Q_gens=kinetics.Qs),
    redeclare model InternalTraceMassGen =
        TRANSFORM.Fluid.ClosureRelations.InternalMassGeneration.Models.DistributedVolume_TraceMass_1D.GenericMassGeneration
        (mC_gens=kinetics.mC_gens))
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

  Fluid.Pipes.GenericPipe_MultiTransferSurface           pipe1(
    redeclare package Medium = Medium,
    m_flow_a_start=1,
    use_HeatTransfer=true,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=d,
        length=L,
        nV=10),
    redeclare model InternalHeatGen =
        Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration,
    p_a_start=100000,
    T_a_start=773.15,
    T_b_start=573.15,
    redeclare model InternalTraceMassGen =
        Fluid.ClosureRelations.InternalMassGeneration.Models.DistributedVolume_TraceMass_1D.GenericMassGeneration
        (mC_gens=mC_gens2))
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow_multi    boundary2(
      nPorts=pipe1.nV, Q_flow=fill(-5e4, boundary2.nPorts))
    annotation (Placement(transformation(extent={{2,10},{22,30}})));

  Fluid.Sensors.TraceSubstancesTwoPort_multi traceSubstance(redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{50,10},{70,-10}})));
  TRANSFORM.Nuclear.ReactorKinetics.PointKinetics_Drift kinetics(
    nV=pipe.nV,
    Q_nominal=5e4*pipe.nV,
    Ts=pipe.mediums.T,
    mCs=pipe.mCs,
    Ts_reference=linspace(
        300 + 273.15,
        500 + 273.15,
        pipe.nV))
    annotation (Placement(transformation(extent={{-32,26},{-12,46}})));

  parameter Integer nV = pipe.nV;

  parameter Integer nI = 6
    "Number of groups of the delayed-neutron precursors groups"
     annotation (Dialog(tab="Kinetics", group="Neutron Kinetics Parameters"));
  parameter TRANSFORM.Units.inverseTime[nI] lambda_i={0.0125,0.0318,0.109,0.317,1.35,8.64}
    "Decay constants for each precursor group"
    annotation (Dialog(tab="Kinetics", group="Neutron Kinetics Parameters"));
  parameter TRANSFORM.Units.nonDim[nI] alpha_i={0.0320,0.1664,0.1613,0.4596,0.1335,0.0472} "Delayed neutron precursor fractions"
    annotation (Dialog(tab="Kinetics", group="Neutron Kinetics Parameters"));
  parameter TRANSFORM.Units.nonDim[nI] beta_i=alpha_i*Beta "Delayed neutron precursor fractions"
    annotation (Dialog(tab="Kinetics", group="Neutron Kinetics Parameters"));
  parameter TRANSFORM.Units.nonDim Beta=0.0065 "Effective delay neutron fraction [e.g.,Beta = sum(beta_i)]";
  parameter Units.nonDim nu_bar = 2.4 "Neutrons per fission";
  parameter SI.Energy w_f = 200e6*1.6022e-19 "Energy released per fission";
  parameter SI.Time Lambda = 1e-5 "Prompt neutron generation time" annotation (Dialog(tab="Kinetics", group="Neutron Kinetics Parameters"));

  SI.Temperature[nV] Ts=pipe.mediums.T;
  SI.Temperature[nV] Ts1=pipe1.mediums.T;
  SI.Power[nV] Q_gens=kinetics.Qs;

  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=2, x={kinetics.Qs[6],
        pipe.mCs[6, 3]})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation

  connect(boundary1.ports[1], pipe.port_a)
    annotation (Line(points={{-40,0},{-30,0}}, color={0,127,255}));
  connect(pipe.port_b, pipe1.port_a)
    annotation (Line(points={{-10,0},{20,0}},color={0,127,255}));
  connect(boundary2.port, pipe1.heatPorts[:, 1])
    annotation (Line(points={{22,20},{30,20},{30,5}}, color={191,0,0}));
  connect(pipe1.port_b, traceSubstance.port_a)
    annotation (Line(points={{40,0},{50,0}}, color={0,127,255}));
  connect(traceSubstance.port_b, boundary.ports[1])
    annotation (Line(points={{70,0},{80,0}}, color={0,127,255}));
  connect(traceSubstance.C, boundary1.C_in) annotation (Line(points={{60,-11},{60,
          -32},{-72,-32},{-72,-8},{-60,-8}}, color={0,0,127}));
  annotation (
      experiment(StopTime=1000, __Dymola_NumberOfIntervals=1000));
end PointKinetics_Drift_Test;
