within TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Examples;
model PointKinetics_Drift_Test_flat_sparseMatrix_modular
  import TRANSFORM;
  extends TRANSFORM.Icons.Example;
  replaceable package Medium =
      TRANSFORM.Media.Fluids.FLiBe.LinearFLiBe_pT (
  extraPropertiesNames=core_kinetics.extraPropertiesNames,
  C_nominal=core_kinetics.C_nominal);
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
  parameter Integer nV = 10;

  //Comment/Uncomment as a block - BIG DATA
//  record Data_FP = FissionProducts.fissionProducts_test3;
//  parameter Real mCs_start[2237+6] = cat(1,fill(0,6),fill(0,1008),{1e30},fill(0,2237-1008-1));
//  parameter Integer i_noGen[:]={1009};

  //Comment/Uncomment as a block - SMALL DATA
  record Data_FP =
      TRANSFORM.Nuclear.ReactorKinetics.SparseMatrix.Data.Isotopes.Isotopes_TeIXeU;
  parameter Real mCs_start[6+4]=cat(1,fill(0,6),{0,0,0,1.43e24});
  parameter Integer i_noGen[:]={4};

public
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
    C_a_start=mCs_start/3.56245,
    C_b_start=mCs_start/3.56245,
    m_flow_a_start=1,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe
        (
        nV=nV,
        dimensions=Ds,
        dlengths=fill(H/core.nV, core.nV)),
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=core_kinetics.mC_gens),
    p_a_start=100000,
    T_a_start=573.15,
    T_b_start=773.15,
    redeclare model InternalHeatGen =
        TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration
        (Q_gens=core_kinetics.Qs + core_kinetics.fissionProducts.Qs_far))
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));
  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface loop_(
    redeclare package Medium = Medium,
    C_a_start=mCs_start/6.5968,
    C_b_start=mCs_start/6.5968,
    m_flow_a_start=1,
    use_HeatTransfer=true,
    redeclare model InternalHeatGen =
        TRANSFORM.Fluid.ClosureRelations.InternalVolumeHeatGeneration.Models.DistributedVolume_1D.GenericHeatGeneration,
    redeclare model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.GenericPipe
        (
        nV=nV,
        dimensions=Ds1,
        dlengths=fill(L/loop_.nV, loop_.nV)),
    redeclare model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens_loop),
    p_a_start=100000,
    T_a_start=773.15,
    T_b_start=573.15)
    annotation (Placement(transformation(extent={{6,-10},{26,10}})));

  TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow_multi heat_rejection(nPorts=
        loop_.nV, Q_flow=fill(-5e4, heat_rejection.nPorts))
    annotation (Placement(transformation(extent={{46,10},{26,30}})));
  TRANSFORM.Fluid.Sensors.TraceSubstancesTwoPort_multi Concentration_Measure(
      redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{36,10},{56,-10}})));
public
  PointKinetics_L1_atomBased_external_sparseMatrix_modular core_kinetics(
    nV=core.nV,
    Q_nominal=5e4*core.nV,
    specifyPower=true,
    redeclare record Data_PG =
        TRANSFORM.Nuclear.ReactorKinetics.Data.PrecursorGroups.precursorGroups_6_FLiBeFueledSalt,
    Q_fission_input=Q_fission.y,
    Vs=core.Vs*core.nParallel,
    SigmaF=26,
    redeclare record Data_FP = Data_FP,
    mCs=core.mCs*core.nParallel,
    nFeedback=1,
    alphas_feedback={-1e-4},
    vals_feedback={core.summary.T_effective},
    vals_feedback_reference={400 + 273.15},
    use_noGen=true,
    i_noGen=i_noGen)
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));

  TRANSFORM.Units.ExtraPropertyFlowRate mC_gens_loop[loop_.nV,core_kinetics.nC]=
     cat(
      2,
      mC_gens_loop_PG,
      mC_gens_loop_FP);
  TRANSFORM.Units.ExtraPropertyFlowRate mC_gens_loop_PG[loop_.nV,core_kinetics.nPG];
  TRANSFORM.Units.ExtraPropertyFlowRate mC_gens_loop_FP[loop_.nV,core_kinetics.nFP];

  Modelica.Blocks.Sources.Step Q_fission(
    height=-5e4*core.nV/2,
    offset=5e4*core.nV,
    startTime=2.5e5)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
equation

  for i in 1:loop_.nV loop
    for j in 1:core_kinetics.nPG loop
      mC_gens_loop_PG[i, j] = -core_kinetics.kinetics.data.lambdas[j]*loop_.mCs[i, j]*
        loop_.nParallel;
    end for;
    for j in 1:core_kinetics.nFP loop
      mC_gens_loop_FP[i, j] = sum({core_kinetics.fissionProducts.data.l_lambdas[
        sum(core_kinetics.fissionProducts.data.l_lambdas_count[1:j - 1]) + k]*
        loop_.mCs[i, core_kinetics.fissionProducts.data.l_lambdas_col[sum(
        core_kinetics.fissionProducts.data.l_lambdas_count[1:j - 1]) + k] +
        core_kinetics.nPG]*loop_.nParallel for k in 1:core_kinetics.fissionProducts.data.l_lambdas_count[
        j]}) - core_kinetics.fissionProducts.data.lambdas[j]*loop_.mCs[i, j +
        core_kinetics.nPG]*loop_.nParallel;
    end for;
  end for;

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
  connect(Concentration_Measure.C, core_inlet.C_in) annotation (Line(points={{46,-3.6},
          {46,-20},{-60,-20},{-60,-8},{-56,-8}},         color={0,0,127}));
  annotation (
      experiment(
      StopTime=500000,
      __Dymola_NumberOfIntervals=100000,
      __Dymola_Algorithm="Esdirk45a"));
end PointKinetics_Drift_Test_flat_sparseMatrix_modular;
