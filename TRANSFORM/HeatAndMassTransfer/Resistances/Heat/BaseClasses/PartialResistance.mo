within TRANSFORM.HeatAndMassTransfer.Resistances.Heat.BaseClasses;
partial model PartialResistance "Base thermal resistance model"
    extends TRANSFORM.Fluid.Interfaces.Records.Visualization_showName;
  SI.ThermalResistance R "Thermal resistance";
  Interfaces.HeatPort_Flow port_a "Heat port at one end of the resistance"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}}),
        iconTransformation(extent={{-80,-10},{-60,10}})));
  Interfaces.HeatPort_Flow port_b "Heat port at the other end of the resistance"
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
          textColor={0,0,255},
          visible=showName)}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Base of the thermal resistances: the heat flow rate from <code>port_a</code> to <code>port_b</code> is <code>(port_a.T - port_b.T)/R</code>, and a class that extends it sets only <code>R</code>. The resistance stores no heat, so the heat flow rate is the same at both ports at every instant; <code>Volumes.SimpleWall</code> and <code>DiscritizedModels.Conduction_1D</code> are walls that store heat.</p>
</html>"));
end PartialResistance;
