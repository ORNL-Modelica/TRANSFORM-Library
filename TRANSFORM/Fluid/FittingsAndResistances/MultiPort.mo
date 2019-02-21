within TRANSFORM.Fluid.FittingsAndResistances;
model MultiPort
  "Multiply a port; useful if multiple connections shall be made to a port exposing a state"
  function positiveMax
    extends Modelica.Icons.Function;
    input Real x;
    output Real y;
  algorithm
    y :=max(x, 1e-10);
  end positiveMax;
  import Modelica.Constants;
  replaceable package Medium=Modelica.Media.Interfaces.PartialMedium annotation(choicesAllMatching);
  // Ports
  parameter Integer nPorts_b=0
    "Number of outlet ports (mass is distributed evenly between the outlet ports"
    annotation(Dialog(connectorSizing=true));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium=Medium)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b[nPorts_b](
    redeclare each package Medium=Medium)
    annotation (Placement(transformation(extent={{30,40},{50,-40}})));
  Medium.MassFraction ports_b_Xi_inStream[nPorts_b,Medium.nXi]
    "inStream mass fractions at ports_b";
  Medium.ExtraProperty ports_b_C_inStream[nPorts_b,Medium.nC]
    "inStream extra properties at ports_b";
equation
  // Only one connection allowed to a port to avoid unwanted ideal mixing
  for i in 1:nPorts_b loop
    assert(cardinality(ports_b[i]) <= 1,"
each ports_b[i] of boundary shall at most be connected to one component.
If two or more connections are present, ideal mixing takes
place with these connections, which is usually not the intention
of the modeller. Increase nPorts_b to add an additional port.
");
  end for;
  // mass and momentum balance
  0 = port_a.m_flow + sum(ports_b.m_flow);
  ports_b.p = fill(port_a.p, nPorts_b);
  // mixing at port_a
  port_a.h_outflow = sum({positiveMax(ports_b[j].m_flow)*inStream(ports_b[j].h_outflow) for j in 1:nPorts_b})
                       / sum({positiveMax(ports_b[j].m_flow) for j in 1:nPorts_b});
  for j in 1:nPorts_b loop
     // expose stream values from port_a to ports_b
     ports_b[j].h_outflow  = inStream(port_a.h_outflow);
     ports_b[j].Xi_outflow = inStream(port_a.Xi_outflow);
     ports_b[j].C_outflow  = inStream(port_a.C_outflow);
     ports_b_Xi_inStream[j,:] = inStream(ports_b[j].Xi_outflow);
     ports_b_C_inStream[j,:] = inStream(ports_b[j].C_outflow);
  end for;
  for i in 1:Medium.nXi loop
    port_a.Xi_outflow[i] = (positiveMax(ports_b.m_flow)*ports_b_Xi_inStream[:,i])
                         / sum(positiveMax(ports_b.m_flow));
  end for;
  for i in 1:Medium.nC loop
    port_a.C_outflow[i] = (positiveMax(ports_b.m_flow)*ports_b_C_inStream[:,i])
                         / sum(positiveMax(ports_b.m_flow));
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-40,
            -100},{40,100}}), graphics={
        Line(
          points={{-40,0},{40,0}},
          color={0,128,255},
          thickness=1),
        Line(
          points={{-40,0},{40,26}},
          color={0,128,255},
          thickness=1),
        Line(
          points={{-40,0},{40,-26}},
          color={0,128,255},
          thickness=1),
        Text(
          extent={{-150,100},{150,60}},
          lineColor={0,0,255},
          textString="%name")}),
                          Documentation(info="<html>
<p>
This model is useful if multiple connections shall be made to a port of a volume model exposing a state,
like a pipe with ModelStructure av_vb.
The mixing is shifted into the volume connected to port_a and the result is propagated back to each ports_b.
</p>
<p>
If multiple connections were directly made to the volume,
then ideal mixing would take place in the connection set, outside the volume. This is normally not intended.
</p>
</html>"));
end MultiPort;
