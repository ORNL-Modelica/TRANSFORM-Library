within TRANSFORM.Nuclear.ReactorKinetics.Examples;
model PointKinetics_Drift_Test_feedback_Xenon
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;

  replaceable package Medium =
      TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_pT (
  extraPropertiesNames=core_kinetics.summary_data.extraPropertiesNames,
  C_nominal=core_kinetics.summary_data.C_nominal);

  parameter SI.Length H = 3.4;
  parameter SI.Length L = 6.296;
  parameter SI.Velocity v=0.4772;
  parameter SI.Length Ds[core.nV] = {sqrt(4*m_flow/rhos[i]/v/Modelica.Constants.pi) for i in 1:core.nV};
  parameter SI.Length Ds1[loop_.nV] = {sqrt(4*m_flow/rhos1[i]/v/Modelica.Constants.pi) for i in 1:loop_.nV};
  parameter SI.MassFlowRate m_flow = 1;

  parameter SI.Temperature[core.nV] Tsr = linspace(300+273.15,500+273.15,core.nV);
  parameter SI.Temperature[loop_.nV] Tsr1 = linspace(500+273.15,300+273.15,loop_.nV);
  parameter SI.Pressure[core.nV] ps = 1e5*ones(core.nV);
  parameter SI.Pressure[loop_.nV] ps1 = 1e5*ones(loop_.nV);
  parameter SI.Density[core.nV] rhos = Medium.density_pT(ps,Tsr);
  parameter SI.Density[loop_.nV] rhos1 = Medium.density_pT(ps1,Tsr1);

  SIadd.ExtraPropertyFlowRate[loop_.nV,core_kinetics.summary_data.nC] mC_gens_pipe1={{
      -core_kinetics.summary_data.lambdas[j]*loop_.mCs[i, j]*loop_.nParallel +
      mC_gens_pipe1_PtoD[i, j] for j in 1:core_kinetics.summary_data.nC} for i in 1:
      loop_.nV};
  SIadd.ExtraPropertyFlowRate[loop_.nV,core_kinetics.summary_data.nC]
    mC_gens_pipe1_PtoD={{sum({core_kinetics.summary_data.lambdas[k] .* loop_.mCs[i, k]
       .* loop_.nParallel .* core_kinetics.summary_data.parents[j, k] for k in 1:
      core_kinetics.summary_data.nC}) for j in 1:core_kinetics.summary_data.nC} for i in 1:
      loop_.nV};

  SI.Temperature[core.nV] Ts=core.mediums.T;
  SI.Temperature[loop_.nV] Ts1=loop_.mediums.T;
  SI.Power[core.nV] Q_gens=core_kinetics.Qs;
  SI.Power Power=sum(core_kinetics.Qs);
  SI.Power Power_beta=sum(core_kinetics.Qs_decay);
  SI.Power Power_gamma=sum(core_kinetics.fissionProducts.Qs_far);
  SI.Power Power_DH = Power_beta + Power_gamma;
  SI.Power Power_total = Power_DH + Power;

  TRANSFORM.Fluid.BoundaryConditions.Boundary_pT back_to_core(
    nPorts=1,
    redeclare package Medium = Medium,
    p=100000) annotation (Placement(transformation(extent={{86,-10},{66,10}})));
  TRANSFORM.Fluid.BoundaryConditions.MassFlowSource_T core_inlet(
    nPorts=1,
    redeclare package Medium = Medium,
    m_flow=1,
    use_C_in=true,
    C=fill(1e-6, Medium.nC),
    T=573.15)
    annotation (Placement(transformation(extent={{-56,-10},{-36,10}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface core(
    redeclare package Medium = Medium,
    m_flow_a_start=1,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe
        (
        nV=10,
        dimensions=Ds,
        dlengths=fill(H/core.nV,core.nV)),
    redeclare model InternalHeatGen =
        TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
        (Q_gens=core_kinetics.Qs + core_kinetics.fissionProducts.Qs_far),
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=cat(
            2,
            core_kinetics.mC_gens,
            core_kinetics.fissionProducts.mC_gens,
            core_kinetics.fissionProducts.mC_gens_TR)),
    p_a_start=100000,
    T_a_start=573.15)
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));

  Fluid.Pipes.GenericPipe_MultiTransferSurface           loop_(
    redeclare package Medium = Medium,
    m_flow_a_start=1,
    use_HeatTransfer=true,
    redeclare model InternalHeatGen =
        Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration,
    redeclare model Geometry =
        Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe
        (
        nV=10,
        dimensions=Ds1,
        dlengths=fill(L/loop_.nV,loop_.nV)),
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens_pipe1),
    p_a_start=100000,
    T_a_start=773.15,
    T_b_start=573.15)
    annotation (Placement(transformation(extent={{6,-10},{26,10}})));

  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow_multi heat_rejection(
      nPorts=loop_.nV, Q_flow=fill(-5e4, heat_rejection.nPorts))
    annotation (Placement(transformation(extent={{46,10},{26,30}})));

  Fluid.Sensors.TraceSubstancesTwoPort_multi Concentration_Measure(redeclare
      package Medium = Medium)
    annotation (Placement(transformation(extent={{36,10},{56,-10}})));

  TRANSFORM.Nuclear.ReactorKinetics.PointKinetics_L1_atomBased_external
    core_kinetics(
    nV=core.nV,
    Q_nominal=0,
    specifyPower=false,
    Vs=core.Vs*core.nParallel,
    SigmaF_start=26,
    mCs=core.mCs[:, core_kinetics.summary_data.iPG[1]:core_kinetics.summary_data.iPG[
        2]]*core.nParallel,
    mCs_FP=core.mCs[:, core_kinetics.summary_data.iFP[1]:core_kinetics.summary_data.iFP[
        2]]*core.nParallel,
    nFeedback=1,
    redeclare record Data_FP =
        TRANSFORM.Nuclear.ReactorKinetics.Data.FissionProducts.fissionProducts_TeIXe_U235,

    redeclare record Data =
        TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.precursorGroups_6_FLiBeFueledSalt,

    SF_Qs_fission=sin(Modelica.Constants.pi/H*core.summary.xpos)/sum(sin(
        Modelica.Constants.pi/H*core.summary.xpos)),
    rhos_input=Reactivity.y,
    alphas_feedback={-1e-4},
    vals_feedback={core.summary.T_effective},
    vals_feedback_reference={400 + 273.15},
    Ns_external=1)
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));

  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=3, x={core_kinetics.Qs[
        6],core.mCs[6, 3],sum(core_kinetics.Qs_decay[6, :])})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  Modelica.Blocks.Sources.Pulse Reactivity(
    nperiod=1,
    startTime=6*60*60,
    offset=-1,
    width=90,
    period=100*60*60/0.9,
    amplitude=1)
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));

equation

  connect(core_inlet.ports[1], core.port_a)
    annotation (Line(points={{-36,0},{-26,0}}, color={0,127,255}));
  connect(core.port_b,loop_. port_a)
    annotation (Line(points={{-6,0},{6,0}},  color={0,127,255}));
  connect(heat_rejection.port, loop_.heatPorts[:, 1])
    annotation (Line(points={{26,20},{16,20},{16,5}}, color={191,0,0}));
  connect(loop_.port_b, Concentration_Measure.port_a)
    annotation (Line(points={{26,0},{36,0}}, color={0,127,255}));
  connect(Concentration_Measure.port_b, back_to_core.ports[1])
    annotation (Line(points={{56,0},{66,0}}, color={0,127,255}));
  connect(Concentration_Measure.C, core_inlet.C_in) annotation (Line(points={{
          46,-11},{46,-20},{-60,-20},{-60,-8},{-56,-8}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=741600, __Dymola_NumberOfIntervals=74160));
end PointKinetics_Drift_Test_feedback_Xenon;
