within TRANSFORM.Fluid.Pipes.Examples.SpeciesTransportProgressionProblems;
model Problem_6 "Core & Loop | Decay | Advection | Periodic | Generation"
  extends BaseClasses.PartialProgressionProblemCoreLoop(
    v=0.02,
    mC_gens={{-lambda_i[j]*pipe.mCs[i, j]*pipe.nParallel + 0.01*sin(Modelica.Constants.pi
        *pipe.summary.xpos_norm[j]) for j in 1:nC} for i in 1:nV},
    boundary(use_C_in=true));

equation

  connect(sensor_C.C, boundary.C_in) annotation (Line(points={{40,-3.6},{40,-20},
          {-90,-20},{-90,-8},{-80,-8}}, color={0,0,127}));
end Problem_6;
