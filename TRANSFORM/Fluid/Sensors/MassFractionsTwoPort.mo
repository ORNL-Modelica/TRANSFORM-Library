within TRANSFORM.Fluid.Sensors;
model MassFractionsTwoPort "Ideal two port sensor for mass fraction"
  extends TRANSFORM.Fluid.Sensors.BaseClasses.PartialTwoPortSensor;
  extends Modelica.Icons.RotationalSensor;
  Modelica.Blocks.Interfaces.RealOutput Xi "Mass fraction in port medium"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=90,
        origin={0,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,110})));
  parameter String substanceName = "water" "Name of mass fraction";

protected
  parameter Integer ind(fixed=false)
    "Index of species in vector of independent mass fractions";
initial algorithm
  ind:= -1;
  for i in 1:Medium.nC loop
    if ( Modelica.Utilities.Strings.isEqual(Medium.substanceNames[i], substanceName)) then
      ind := i;
    end if;
  end for;
  assert(ind > 0, "Mass fraction '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check sensor parameter and medium model.");
equation
  if allowFlowReversal then
     Xi = Modelica.Fluid.Utilities.regStep(port_a.m_flow, port_b.Xi_outflow[ind], port_a.Xi_outflow[ind], m_flow_small);
  else
     Xi = port_b.Xi_outflow[ind];
  end if;
annotation (defaultComponentName="massFraction",
  Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{10,104},{-72,74}},
          lineColor={0,0,0},
          textString="Xi"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255})}),
  Documentation(info="<html>
<p>
This component monitors the mass fraction of the passing fluid.
The sensor is ideal, i.e., it does not influence the fluid.
</p> </html>",
             revisions="<html>
<ul>
<li>2011-12-14: Stefan Wischhusen: Initial Release.</li>
</ul>
</html>"));
end MassFractionsTwoPort;
