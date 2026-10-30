within TRANSFORM.HeatAndMassTransfer.Resistances.Mass.BaseClasses;
partial model PartialResistance
  parameter Integer nC = 1 "Number of substances";
  Units.DiffusionResistance R[nC] "Diffusion resistance";
  Interfaces.MolePort_Flow port_a(nC=nC) annotation (Placement(transformation(
          extent={{-80,-10},{-60,10}}), iconTransformation(extent={{-80,-10},{-60,
            10}})));
  Interfaces.MolePort_Flow port_b(nC=nC) annotation (Placement(transformation(
          extent={{60,-10},{80,10}}), iconTransformation(extent={{60,-10},{80,
            10}})));
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
equation
  port_a.n_flow + port_b.n_flow = zeros(nC);
  port_a.n_flow = (port_a.C - port_b.C)./R;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                               Bitmap(extent={{-70,-70},{70,70}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/resistanceMass.png"),
        Text(
          extent={{-150,92},{150,52}},
          textString="%name",
          visible=showName,
          lineColor={0,0,255})}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialResistance;
