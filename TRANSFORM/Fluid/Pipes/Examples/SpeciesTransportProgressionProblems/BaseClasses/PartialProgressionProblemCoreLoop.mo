within TRANSFORM.Fluid.Pipes.Examples.SpeciesTransportProgressionProblems.BaseClasses;
partial model PartialProgressionProblemCoreLoop
  extends BaseClasses.PartialProgressionProblemCore;

  SIadd.ExtraPropertyConcentration C_i_loop[nV,nC];

  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens_loop={{-lambda_i[j]*pipe_loop.mCs[i, j]*pipe_loop.nParallel for j in 1:nC} for i in 1:nV};

  Pipes.GenericPipe_MultiTransferSurface pipe(
    redeclare package Medium = Medium,
    Cs_start=Cs_start,
    p_a_start=p_start,
    T_a_start=T_start,
    m_flow_a_start=m_flow,
    redeclare replaceable model Geometry =
        TRANSFORM.Fluid.ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe
        (
        dimension=dimension,
        length=length,
        nV=nV),
    redeclare replaceable model InternalTraceGen =
        TRANSFORM.Fluid.ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens))
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  BoundaryConditions.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    use_C_in=false,
    m_flow=m_flow,
    T=T_start,
    C=Cs_inlet,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  BoundaryConditions.Boundary_pT boundary1(
    redeclare package Medium = Medium,
    p=p_start,
    T=T_start,
    nPorts=1) annotation (Placement(transformation(extent={{80,-10},{60,10}})));

  Sensors.TraceSubstancesTwoPort_multi sensor_C(redeclare package Medium =
        Medium, allowFlowReversal=false)
    annotation (Placement(transformation(extent={{30,10},{50,-10}})));

  TRANSFORM.Fluid.Pipes.GenericPipe_MultiTransferSurface pipe_loop(
    redeclare package Medium = Medium,
    p_a_start=p_start,
    T_a_start=T_start,
    m_flow_a_start=m_flow,
    redeclare model Geometry =
        ClosureRelations.Geometry.Models.DistributedVolume_1D.StraightPipe (
        dimension=dimension,
        length=length,
        nV=nV),
    redeclare model InternalTraceGen =
        ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration
        (mC_gens=mC_gens_loop))
                annotation (Placement(transformation(extent={{0,-10},{20,10}})));

equation

  // Create variable for volume based concentration
  for j in 1:nV loop
    for i in 1:nC loop
      C_i_loop[j, i] = pipe_loop.Cs[j, i]*pipe_loop.mediums[j].d;
    end for;
  end for;

  connect(pipe_loop.port_b, sensor_C.port_a)
    annotation (Line(points={{20,0},{30,0}}, color={0,127,255}));
  connect(pipe.port_b, pipe_loop.port_a)
    annotation (Line(points={{-20,0},{0,0}}, color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=100,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end PartialProgressionProblemCoreLoop;
