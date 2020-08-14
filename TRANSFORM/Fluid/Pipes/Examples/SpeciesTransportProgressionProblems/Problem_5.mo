within TRANSFORM.Fluid.Pipes.Examples.SpeciesTransportProgressionProblems;
model Problem_5 "Core | Decay | Advection | Periodic | Generation"
  extends Problem_4(mC_gens={{-lambda_i[j]*pipe.mCs[i, j]*pipe.nParallel + 0.01*
        sin(Modelica.Constants.pi*pipe.summary.xpos_norm[j]) for j in 1:nC}
        for i in 1:nV});

end Problem_5;
