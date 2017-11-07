within TRANSFORM.HeatAndMassTransfer.DiscritizedModels.ClassicalMethod.BoundaryConditions;
model Adiabatic_FD "Adiabatic boundary condition for finite difference methods"

  parameter Integer nNodes(min=2);

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nNodes] port annotation (
      Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));

equation
  for i in 1:nNodes loop
    port[i].Q_flow = 0;
  end for;
  annotation (defaultComponentName="adiabatic",
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}),     graphics={
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Rectangle(
          extent={{100,100},{60,-100}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,-16},{60,20}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,24},{60,60}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,64},{60,100}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,-56},{60,-20}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,-96},{60,-60}},
          color={255,0,0},
          thickness=0.5)}),
    Documentation(info="<html>
<p>This model defines an adiabatic boundary condition (Q_flow = 0) for all nodes.</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Rectangle(
          extent={{100,100},{60,-100}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,-16},{60,20}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,24},{60,60}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,64},{60,100}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,-56},{60,-20}},
          color={255,0,0},
          thickness=0.5),
        Line(
          points={{0,-96},{60,-60}},
          color={255,0,0},
          thickness=0.5)}));
end Adiabatic_FD;
