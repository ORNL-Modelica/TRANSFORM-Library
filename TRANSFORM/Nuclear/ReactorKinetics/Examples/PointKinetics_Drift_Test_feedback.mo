within TRANSFORM.Nuclear.ReactorKinetics.Examples;
model PointKinetics_Drift_Test_feedback
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;

  replaceable package Medium =
      TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_pT (
  extraPropertiesNames=data_traceSubstances.extraPropertiesNames,
  C_nominal=data_traceSubstances.C_nominal);


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

  SIadd.ExtraPropertyFlowRate [loop_.nV,data_traceSubstances.nC] mC_gens_pipe1 = {{-data_traceSubstances.lambdas[j]*loop_.mCs[
      i, j]                                                                                                           *loop_.nParallel + mC_gens_pipe1_PtoD[i,j] for j in 1:data_traceSubstances.nC} for i in 1:loop_.nV};
  SIadd.ExtraPropertyFlowRate[loop_.nV,data_traceSubstances.nC] mC_gens_pipe1_PtoD = {{sum({data_traceSubstances.lambdas[k].*loop_.mCs[
      i, k]                                                                                                                    .*loop_.nParallel.*data_traceSubstances.parents[j,k] for k in 1:data_traceSubstances.nC}) for j in 1:data_traceSubstances.nC} for i in 1:loop_.nV};

  SI.Temperature[core.nV] Ts=core.mediums.T;
  SI.Temperature[loop_.nV] Ts1=loop_.mediums.T;
  SI.Power[core.nV] Q_gens=core_kinetics.Qs;
  SI.Power Power=sum(core_kinetics.Qs);
  SI.Power Power_beta=sum(core_kinetics.Qs_FP_near);
  SI.Power Power_gamma=sum(core_kinetics.Qs_FP_far);
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
        (Q_gens=core_kinetics.Qs +core_kinetics.Qs_FP_near
                                                       +core_kinetics.Qs_FP_far),
    p_a_start=100000,
    T_a_start=573.15,
    T_b_start=773.15,
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=cat(
            2,
            core_kinetics.mC_gens,
            core_kinetics.mC_gens_FP,
            core_kinetics.mC_gens_TR)))
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
public
  TRANSFORM.Nuclear.ReactorKinetics.PointKinetics_Drift core_kinetics(
    nV=core.nV,
    Q_nominal=5e4*core.nV,
    Qs_input=fill(core_kinetics.Q_nominal/core_kinetics.nV, core_kinetics.nV),
    mCs=core.mCs[:, data_traceSubstances.iPG[1]:data_traceSubstances.iPG[2]]*
        core.nParallel,
    lambda_i=data_traceSubstances.precursorGroups.lambdas,
    nC=data_traceSubstances.fissionProducts.nC,
    parents=data_traceSubstances.fissionProducts.parents,
    lambda_FP=data_traceSubstances.fissionProducts.lambdas,
    w_FP_decay=data_traceSubstances.fissionProducts.w_decay,
    mCs_FP=core.mCs[:, data_traceSubstances.iFP[1]:data_traceSubstances.iFP[2]]
        *core.nParallel,
    sigmaA_FP=data_traceSubstances.fissionProducts.sigmaA_thermal,
    vals_feedback=matrix(core.mediums.T),
    wG_FP_decay=data_traceSubstances.fissionProducts.wG_decay,
    Vs=core.Vs*core.nParallel,
    nTR=data_traceSubstances.tritium.nC,
    SigmaF=26,
    nFS=data_traceSubstances.fissionProducts.nFS,
    fissionSource=fill(1/core_kinetics.nFS, core_kinetics.nFS),
    specifyPower=false,
    fissionYield=fill(
        0,
        core_kinetics.nC,
        core_kinetics.nFS),
    vals_feedback_reference=matrix({TRANSFORM.Math.Sigmoid(
        core.summary.xpos_norm[i],
        0.5,
        10)*200 + 573.15 for i in 1:core.nV}))
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));

  TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(n=3, x={core_kinetics.Qs[
        6],core.mCs[6, 3],core_kinetics.Qs_FP_near[6]})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

protected
  TRANSFORM.Examples.MoltenSaltReactor.Data.data_traceSubstances
    data_traceSubstances(redeclare record PrecursorGroups =
        TRANSFORM.Examples.MoltenSaltReactor.Data.PrecursorGroups.precursorGroups_6_description,
      redeclare record FissionProducts =
        TRANSFORM.Examples.MoltenSaltReactor.Data.FissionProducts.fissionProducts_TeIXe_U235)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
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
    experiment(StopTime=100000000, __Dymola_NumberOfIntervals=10000));
end PointKinetics_Drift_Test_feedback;
