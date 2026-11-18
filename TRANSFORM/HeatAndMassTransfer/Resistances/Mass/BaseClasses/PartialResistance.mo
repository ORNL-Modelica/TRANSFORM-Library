within TRANSFORM.HeatAndMassTransfer.Resistances.Mass.BaseClasses;
partial model PartialResistance "Base mass transfer resistance model"
  extends TRANSFORM.Fluid.Interfaces.Records.Visualization_showName;
  parameter Integer nC = 1 "# of substances";
  SItf.DiffusionResistance R[nC] "Diffusion resistance";
  Interfaces.MolePort_Flow port_a(nC=nC) "Mole port at one end of the resistance" annotation (Placement(transformation(
          extent={{-80,-10},{-60,10}}), iconTransformation(extent={{-80,-10},{-60,
            10}})));
  Interfaces.MolePort_Flow port_b(nC=nC) "Mole port at the other end of the resistance" annotation (Placement(transformation(
          extent={{60,-10},{80,10}}), iconTransformation(extent={{60,-10},{80,
            10}})));
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
          textColor={0,0,255})}),                                Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Base of the mass transfer resistances: for each of the <code>nC</code> substances, the molar flow rate from <code>port_a</code> to <code>port_b</code> is <code>(port_a.C - port_b.C)/R</code>, and a class that extends it sets only <code>R</code>. The resistance stores no substance, so the molar flow rate is the same at both ports at every instant.</p>
<ul>
<li>The concentrations at the two ports are compared directly. Where the concentration jumps across an interface, as at a liquid-gas surface, put a <code>SolubilityInterface</code> between two resistances.</li>
</ul>
</html>"));
end PartialResistance;
