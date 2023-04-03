within TRANSFORM.Fluid.Pipes.Examples.SpeciesTransportProgressionProblems.BaseClasses;
partial model PartialProgressionProblemCoreLoop
  extends BaseClasses.PartialProgressionProblemCore;

  SIadd.ExtraPropertyConcentration C_i_loop[nV,nC];

  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens_loop={{mC_decay_loop[i, j] + (if use_PtoD then mC_gens_PtoD_loop[i, j] else 0) for j in 1:nC} for i in 1:nV};

  SIadd.ExtraPropertyFlowRate[nV,nC] mC_decay_loop = {{-lambda_i[j]*pipe_loop.mCs[i, j]*pipe_loop.nParallel for j in 1:nC} for i in 1:nV};
  SIadd.ExtraPropertyFlowRate[nV,nC] mC_gens_PtoD_loop={{sum({lambda_i[k]* pipe_loop.mCs[i, k]* pipe_loop.nParallel* parents[j, k] for k in 1:nC}) for j in 1:nC} for i in 1:nV};

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
        ClosureRelations.InternalTraceGeneration.Models.DistributedVolume_Trace_1D.GenericTraceGeneration (
         mC_gens=mC_gens_loop))
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

end PartialProgressionProblemCoreLoop;
