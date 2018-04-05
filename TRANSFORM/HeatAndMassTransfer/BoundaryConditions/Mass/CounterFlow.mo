within TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass;
model CounterFlow
  "Switch mass concentration arrays for counter flow cases"

  parameter Integer nC = 2 "Number of substances";
  parameter Integer n=1 "Number of connected elements";// annotation(Dialog(connectorSizing=true));
  parameter Boolean counterCurrent=false
    "Swap concentration and flux vector order";
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));

  Interfaces.MolePort_Flow port_a[n](each nC=nC)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.MolePort_Flow port_b[n](each nC=nC)
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation

  if not counterCurrent then
    for i in 1:n loop
      port_a[i].n_flow +port_b[i].n_flow  = zeros(nC);
      port_a[i].C = port_b[i].C;
    end for;
  elseif counterCurrent then
    for i in 1:n loop
      port_a[n - (i - 1)].n_flow +port_b[i].n_flow  = zeros(nC);
      port_a[n - (i - 1)].C = port_b[i].C;
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
          fileName="modelica://TRANSFORM/Resources/Images/Icons/counterFlow_mass_true.jpg"),
          Bitmap(
              extent={{-108,-100},{108,100}},
              visible=not counterCurrent,
          fileName="modelica://TRANSFORM/Resources/Images/Icons/counterFlow_mass_false.jpg"),
        Text(
          extent={{-136,100},{144,60}},
          textString="%name",
          lineColor={0,0,255},
          visible=showName)}));
end CounterFlow;
