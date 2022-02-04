within TRANSFORM.Nuclear.ParallelChannels.Examples;
model HotAvgColdChanTest
  HotAvgColdChannels hotAvgColdChannels(
    nHotChannels=1,
    nColdChannels=1,
    nAvgChannels=8)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.BoundaryConditions.Boundary_pT boundary(nPorts=1)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Fluid.BoundaryConditions.Boundary_pT boundary1(nPorts=1)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
equation
  connect(boundary1.ports[1], hotAvgColdChannels.port_b)
    annotation (Line(points={{60,0},{10,0}}, color={0,127,255}));
  connect(boundary.ports[1], hotAvgColdChannels.port_a)
    annotation (Line(points={{-60,0},{-10,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HotAvgColdChanTest;
