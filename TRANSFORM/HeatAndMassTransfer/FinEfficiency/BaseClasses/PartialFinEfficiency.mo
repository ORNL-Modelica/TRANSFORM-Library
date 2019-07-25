within TRANSFORM.HeatAndMassTransfer.FinEfficiency.BaseClasses;
partial model PartialFinEfficiency
  SI.Efficiency eta "Fin efficiency";
  Modelica.Blocks.Interfaces.RealOutput y(unit="1")
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  y = eta;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-150,152},{150,112}},
          textString="%name",
          lineColor={0,0,255}), Rectangle(extent={{-101,101},{100,-100}},
            lineColor={0,0,0})}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialFinEfficiency;
