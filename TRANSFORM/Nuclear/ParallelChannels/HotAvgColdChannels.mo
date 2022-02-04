within TRANSFORM.Nuclear.ParallelChannels;
model HotAvgColdChannels "3 channel model"
  parameter Real nHotChannels;
  parameter Real nColdChannels;
  parameter Real nAvgChannels;
  final parameter Real nChannels = nHotChannels + nAvgChannels + nColdChannels;
  replaceable package Medium = Modelica.Media.Water.StandardWater constrainedby
    Modelica.Media.Interfaces.PartialMedium                                                                             annotation(Dialog(tab="General"));
  Fluid.Pipes.GenericPipe_withWall hotChannel(
    nParallel=nHotChannels,
    exposeState_a=false,
    exposeState_b=true)
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Fluid.Pipes.GenericPipe_withWall coldChannel(exposeState_a=false,
      exposeState_b=true)
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  Fluid.Pipes.GenericPipe_withWall avgChannel(exposeState_a=false,
      exposeState_b=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.Interfaces.FluidPort_Flow port_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Fluid.Interfaces.FluidPort_State port_b
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  connect(port_a, avgChannel.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(hotChannel.port_a, port_a) annotation (Line(points={{-10,70},{-54,70},
          {-54,0},{-100,0}}, color={0,127,255}));
  connect(coldChannel.port_a, port_a) annotation (Line(points={{-10,-70},{-54,-70},
          {-54,0},{-100,0}}, color={0,127,255}));
  connect(avgChannel.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(coldChannel.port_b, port_b) annotation (Line(points={{10,-70},{54,-70},
          {54,0},{100,0}}, color={0,127,255}));
  connect(hotChannel.port_b, port_b) annotation (Line(points={{10,70},{54,70},{54,
          0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HotAvgColdChannels;
