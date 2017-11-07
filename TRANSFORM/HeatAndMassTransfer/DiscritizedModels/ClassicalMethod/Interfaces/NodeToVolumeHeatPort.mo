within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Interfaces;
model NodeToVolumeHeatPort "Converts nodal heat port to volume heat port"

  parameter Integer nNodes(min=3)
    "# nodes (axial or radial) in finite difference";

  final parameter Integer nV=nNodes - 1;

  Modelica.Fluid.Interfaces.HeatPorts_a heatPorts_FD[nNodes]
    "Finite difference connector" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,0}), iconTransformation(
        extent={{-40,-10},{40,10}},
        rotation=-90,
        origin={-100,0})));
  Modelica.Fluid.Interfaces.HeatPorts_b heatPorts_DynP[nV]
    "Dynamic pipe connector" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,0}), iconTransformation(
        extent={{-40,-10},{40,10}},
        rotation=-90,
        origin={100,0})));

equation
  heatPorts_DynP[1].Q_flow + heatPorts_FD[1].Q_flow + 0.5*heatPorts_FD[2].Q_flow = 0;
  for i in 2:nV - 1 loop
    heatPorts_DynP[i].Q_flow + 0.5*(heatPorts_FD[i].Q_flow + heatPorts_FD[i+1].Q_flow) = 0;
  end for;
  heatPorts_DynP[nV].Q_flow + 0.5*heatPorts_FD[nV].Q_flow + heatPorts_FD[nV+1].Q_flow = 0;

  for i in 1:nV loop
    heatPorts_DynP[i].T = 0.5*(heatPorts_FD[i].T + heatPorts_FD[i+1].T);
  end for;

  0.5*heatPorts_DynP[1].Q_flow + heatPorts_FD[1].Q_flow = 0;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-86,36},{86,-34}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{17,-27},{23,-33}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{20,30},{80,30},{80,-30},{20,-30},{20,30}},
          color={0,0,0},
          pattern=LinePattern.Dot,
          thickness=0.5),
        Ellipse(
          extent={{77,-27},{83,-33}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{77,33},{83,27}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{17,33},{23,27}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-83,33},{-77,27}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-80,0},{-80,30},{-20,30},{-20,0}},
          color={0,0,0},
          pattern=LinePattern.Dot,
          thickness=0.5),
        Line(
          points={{-80,0},{-20,0},{-20,-30},{-80,-30},{-80,0}},
          color={0,0,0},
          pattern=LinePattern.Dot,
          thickness=0.5),
        Ellipse(
          extent={{-23,-27},{-17,-33}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-83,-27},{-77,-33}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-23,33},{-17,27}},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-18,18},{18,-18}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="TO")}));
end NodeToVolumeHeatPort;
