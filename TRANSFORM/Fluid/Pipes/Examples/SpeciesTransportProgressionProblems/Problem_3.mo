within TRANSFORM.Fluid.Pipes.Examples.SpeciesTransportProgressionProblems;
model Problem_3 "Core | Decay | Advection | Constant, Non-Zero"
  extends BaseClasses.PartialProgressionProblemCore(v=0.02, C_i_inlet=1000*ones(
         nC));
equation
  connect(pipe.port_b, sensor_C.port_a)
    annotation (Line(points={{-20,0},{30,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Problem_3;
