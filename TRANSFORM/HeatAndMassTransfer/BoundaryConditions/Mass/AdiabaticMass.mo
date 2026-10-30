within TRANSFORM.HeatAndMassTransfer.BoundaryConditions.Mass;
model AdiabaticMass "Adiabatic boundary condition"
  parameter Integer nC = 1 "Number of substances";
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
  Interfaces.MolePort_Flow port(nC=nC) annotation (Placement(transformation(
          extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,
            10}})));
equation
  port.n_flow = zeros(nC);
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
          color={0,127,0},
          thickness=0.5),
        Line(
          points={{0,24},{60,60}},
          color={0,127,0},
          thickness=0.5),
        Line(
          points={{0,-56},{60,-20}},
          color={0,127,0},
          thickness=0.5),
        Text(
          extent={{-100,112},{180,72}},
          textString="%name",
          lineColor={0,0,255},
          visible=showName)}),
    Documentation(info="<html>
<p>This model defines an adiabatic boundary condition (Q_flow = 0) for all nodes.</p>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}})));
end AdiabaticMass;
