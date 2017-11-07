within TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat;
model CounterFlow
  "Switch temperature arrays for counter flow cases"

  parameter Integer n=0 "Number of connected elements";// annotation(Dialog(connectorSizing=true));
  parameter Boolean counterCurrent=false
    "Swap temperature and flux vector order";

  Interfaces.HeatPort_Flow port_a[n]
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.HeatPort_Flow port_b[n]
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation

  if not counterCurrent then
    for i in 1:n loop
      port_a[i].Q_flow + port_b[i].Q_flow = 0;
      port_a[i].T = port_b[i].T;
    end for;
  elseif counterCurrent then
    for i in 1:n loop
      port_a[n - (i - 1)].Q_flow + port_b[i].Q_flow = 0;
      port_a[n - (i - 1)].T = port_b[i].T;
    end for;
  end if;

  annotation (defaultComponentName="counterFlow",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
          graphics={
          Bitmap(
              extent={{-108,-100},{108,100}},
              visible=counterCurrent,
          fileName="modelica://TRANSFORM/Resources/Images/Icons/counterFlow_true.jpg"),
          Bitmap(
              extent={{-108,-100},{108,100}},
              visible=not counterCurrent,
          fileName="modelica://TRANSFORM/Resources/Images/Icons/counterFlow_false.jpg"),
        Text(
          extent={{-136,100},{144,60}},
          textString="%name",
          lineColor={0,0,255})}));
end CounterFlow;
