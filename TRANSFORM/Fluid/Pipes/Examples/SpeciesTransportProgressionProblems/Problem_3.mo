within TRANSFORM.Fluid.Pipes.Examples.SpeciesTransportProgressionProblems;
model Problem_3 "Core | Decay | Advection | Constant, Non-Zero"
  extends Problem_2(C_i_inlet=1000*ones(nC));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Problem_3;
