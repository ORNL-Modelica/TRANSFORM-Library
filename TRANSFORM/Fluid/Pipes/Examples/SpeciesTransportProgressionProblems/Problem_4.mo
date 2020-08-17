within TRANSFORM.Fluid.Pipes.Examples.SpeciesTransportProgressionProblems;
model Problem_4 "Core | Decay | Advection | Periodic"
  extends BaseClasses.PartialProgressionProblemCore(v=0.02, boundary(use_C_in=true));

equation
  connect(pipe.port_b, sensor_C.port_a)
    annotation (Line(points={{-20,0},{30,0}}, color={0,127,255}));
  connect(sensor_C.C, boundary.C_in) annotation (Line(points={{40,-3.6},{40,-20},
          {-90,-20},{-90,-8},{-80,-8}}, color={0,0,127}));
end Problem_4;
