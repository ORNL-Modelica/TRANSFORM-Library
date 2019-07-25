within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.Interfaces;
model ScalePower "Scales power from one heating element to nElem elements"
  parameter Real nParallel=1 "# of parallel heated elements";
  parameter Integer nNodes = 1 "# of nodes";
  parameter Boolean counterCurrent = false
    "Swap temperature and flux vector order";
  Modelica.Fluid.Interfaces.HeatPorts_a heatPorts_a[nNodes] annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,0}), iconTransformation(
        extent={{-40,-10},{40,10}},
        rotation=-90,
        origin={-100,0})));
  Modelica.Fluid.Interfaces.HeatPorts_b heatPorts_b[nNodes] annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,0}), iconTransformation(
        extent={{-40,-10},{40,10}},
        rotation=-90,
        origin={100,0})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow[nNodes]
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
equation
  if not counterCurrent then
    for i in 1:nNodes loop
    prescribedHeatFlow[i].Q_flow =nParallel*heatPorts_a[i].Q_flow;
    prescribedHeatFlow[i].port.T = heatPorts_a[i].T;
    end for;
  elseif counterCurrent then
    for i in 1:nNodes loop
    prescribedHeatFlow[nNodes-(i-1)].Q_flow =nParallel*heatPorts_a[i].Q_flow;
    prescribedHeatFlow[nNodes-(i-1)].port.T = heatPorts_a[i].T;
    end for;
  end if;
  connect(prescribedHeatFlow.port, heatPorts_b)
    annotation (Line(points={{12,0},{100,0}},         color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={Rectangle(
          extent={{-86,38},{86,-38}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),            Text(
          extent={{-28,38},{28,-42}},
          lineColor={0,0,0},
          textString="P -> nElem*P

T -> T")}));
end ScalePower;
