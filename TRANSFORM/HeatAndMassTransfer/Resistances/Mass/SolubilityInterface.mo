within TRANSFORM.HeatAndMassTransfer.Resistances.Mass;
model SolubilityInterface "Solubility equilibrium model at a phase interface"
  parameter Integer nC=1 "# of substances";
  parameter Real nb[nC](each max=3)=fill(1, nC)
    "Exponent on port_b.C/Kb, e.g. 2 for Sievert's law";
  input Real Ka[nC]=fill(1, nC)
    "Solubility coefficient at port_a, e.g. Henry's law"
    annotation (Dialog(group="Inputs"));
  input Real Kb[nC]=fill(1, nC)
    "Solubility coefficient at port_b, e.g. Sievert's law"
    annotation (Dialog(group="Inputs"));
  Interfaces.MolePort_State port_a(nC=nC) "Mole port on one side of the interface" annotation (Placement(transformation(
          extent={{-80,-10},{-60,10}}), iconTransformation(extent={{-80,-10},{-60,
            10}})));
  Interfaces.MolePort_State port_b(nC=nC) "Mole port on the other side of the interface" annotation (Placement(transformation(
          extent={{60,-10},{80,10}}), iconTransformation(extent={{60,-10},{80,
            10}})));
  parameter Boolean showName = true "= true to show the component name on the icon" annotation(Dialog(tab="Visualization"));
equation
  port_a.n_flow + port_b.n_flow = zeros(nC);
  for i in 1:nC loop
    if abs(nb[i]-1) <= Modelica.Constants.eps then
      port_a.C[i]/Ka[i] = port_b.C[i]/Kb[i];
    else
      port_a.C[i]/Ka[i] = TRANSFORM.Math.regExponent_cinterp((port_b.C[i]/Kb[i]),1e-10,nb[i]);
    end if;
  end for;

  annotation (
    defaultComponentName="interface",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Bitmap(extent={{-70,-70},{70,70}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/Resistance_Mass_nonFlow.jpg"),
        Bitmap(extent={{-40,-100},{40,-30}}, fileName=
              "modelica://TRANSFORM/Resources/Images/Icons/SolubilityInterface.jpg"),
        Text(
          extent={{-150,92},{150,52}},
          textString="%name",
          visible=showName,
          textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Equilibrium of a dissolved substance across the interface between two phases, such as a fluid and a wall, where the concentration jumps instead of being the same on both sides. For each substance, <code>port_a.C/Ka = (port_b.C/Kb)^nb</code>.</p>
<ul>
<li>With <code>Ka</code> a Henry's law coefficient and <code>Kb</code> a Sievert's law coefficient, both sides of the equation are the substance's partial pressure when <code>nb = 2</code>, so <code>port_b</code> is the side that follows Sievert's law.</li>
</ul>
</html>"));
end SolubilityInterface;
