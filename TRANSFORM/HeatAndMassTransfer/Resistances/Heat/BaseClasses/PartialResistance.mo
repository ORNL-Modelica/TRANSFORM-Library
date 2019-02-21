within TRANSFORM.HeatAndMassTransfer.Resistances.Heat.BaseClasses;
partial model PartialResistance
    extends TRANSFORM.Fluid.Interfaces.Records.Visualization_showName;
  SI.ThermalResistance R "Thermal resistance";
  Interfaces.HeatPort_Flow port_a
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}}),
        iconTransformation(extent={{-80,-10},{-60,10}})));
  Interfaces.HeatPort_Flow port_b
    annotation (Placement(transformation(extent={{60,-10},{80,10}}),
        iconTransformation(extent={{60,-10},{80,10}})));
equation
  port_a.Q_flow + port_b.Q_flow = 0;
  port_a.Q_flow = (port_a.T - port_b.T)/R;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                               Bitmap(extent={{-70,-70},{70,70}},
            fileName="modelica://TRANSFORM/Resources/Images/Icons/resistanceHeat.png"),
        Text(
          extent={{-140,82},{140,42}},
          textString="%name",
          lineColor={0,0,255},
          visible=showName)}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialResistance;
