within TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Heat;
model Adiabatic "Adiabatic boundary condition"

  Interfaces.HeatPort_Flow port annotation (Placement(transformation(extent={{
            90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
equation
  port.Q_flow = 0;

  annotation (defaultComponentName="adiabatic",
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}),     graphics={
        Rectangle(
          extent={{100,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Forward),
        Line(
          points={{0,-16},{60,20}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,24},{60,60}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,-56},{60,-20}},
          color={255,0,0},
          thickness=0.5),
        Text(
          extent={{-100,112},{180,72}},
          textString="%name",
          lineColor={0,0,255})}),
    Documentation(info="<html>
<p>This model defines an adiabatic boundary condition (Q_flow = 0) for all nodes.</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}})));
end Adiabatic;
