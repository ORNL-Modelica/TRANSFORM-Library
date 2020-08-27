within TRANSFORM.Fluid.Pipes.Examples.SpeciesTransportProgressionProblems;
model Problem_1 "Core | Decay"
  extends BaseClasses.PartialProgressionProblemCore;

equation

  connect(pipe.port_b, sensor_C.port_a)
    annotation (Line(points={{-20,0},{30,0}}, color={0,127,255}));
end Problem_1;
