within TRANSFORM.Fluid.Pipes.Examples.SpeciesTransportProgressionProblems;
model Problem_8
  "Core | Decay | Advection | Periodic | Generation | Multi-species | Cross-species | Cross-section Capture"
  extends BaseClasses.PartialProgressionProblemCore(
    v=0.02,
    boundary(use_C_in=true),
    use_generation=true,
    nC=4,
    lambda_i=TRANSFORM.Math.logspace(
        0.1,
        1,
        nC),
    use_PtoD=true,
    use_capture=true);

equation

  connect(sensor_C.C, boundary.C_in) annotation (Line(points={{40,-3.6},{40,-20},
          {-90,-20},{-90,-8},{-80,-8}}, color={0,0,127}));
  connect(pipe.port_b, sensor_C.port_a)
    annotation (Line(points={{-20,0},{30,0}}, color={0,127,255}));
end Problem_8;
