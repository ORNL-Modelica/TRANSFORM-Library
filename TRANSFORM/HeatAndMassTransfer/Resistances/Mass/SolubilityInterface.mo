within TRANSFORM.HeatAndMassTransfer.Resistances.Mass;
model SolubilityInterface
  parameter Integer nC=1 "Number of substances";
  parameter Real nb[nC]=fill(1, nC)
    "Exponential of (C/kb)^nb (i.e., if Sievert than nb = 2)";
  input Real Ka[nC]=fill(1, nC)
    "port a solubility coefficient (i.e., Henry/Sievert)"
    annotation (Dialog(group="Inputs"));
  input Real Kb[nC]=fill(1, nC)
    "port b solubility coefficient (i.e., Henry/Sievert)"
    annotation (Dialog(group="Inputs"));
  Interfaces.MolePort_State port_a(nC=nC) annotation (Placement(transformation(
          extent={{-80,-10},{-60,10}}), iconTransformation(extent={{-80,-10},{-60,
            10}})));
  Interfaces.MolePort_State port_b(nC=nC) annotation (Placement(transformation(
          extent={{60,-10},{80,10}}), iconTransformation(extent={{60,-10},{80,
            10}})));
  parameter Boolean showName = true annotation(Dialog(tab="Visualization"));
equation
  port_a.n_flow + port_b.n_flow = zeros(nC);
  for i in 1:nC loop
    if abs(nb[i]-1) <= Modelica.Constants.eps then
      port_a.C[i]/Ka[i] = port_b.C[i]/Kb[i];
    else
//       port_a.C[i]/Ka[i] = (port_b.C[i]/Kb[i])^nb[i];
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
          lineColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Implementation of an interfacial solubility calculation to properly account for concentration gradients.</p>
<p>For example,</p>
<p>For a liquid-gas system there is the liquid-gas interface where the concentration at that interface is different than the bulk concentrations based upon the solubility of the species as determined by a law such as Henry&apos;s law which states that the concentration can be related to the partial pressure.</p>
<p>C_i/K_H = P_i</p>
<p>So the concentration changes across the interface for use in mass balance equations depends therefore on the stated type of relation on either side.</p>
</html>"));
end SolubilityInterface;
