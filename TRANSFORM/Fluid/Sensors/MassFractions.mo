within TRANSFORM.Fluid.Sensors;
model MassFractions "Ideal one port mass fraction sensor"
  extends TRANSFORM.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor;
  extends TRANSFORM.Icons.RotationalSensor;

  parameter String substanceName = "water" "Name of mass fraction";

  Modelica.Blocks.Interfaces.RealOutput Xi "Mass fraction in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  parameter Integer ind(fixed=false)
    "Index of species in vector of independent mass fractions";
  Medium.MassFraction XiVec[Medium.nXi]
    "Mass fraction vector, needed because indexed argument for the operator inStream is not supported";
initial algorithm
  ind:= -1;
  for i in 1:Medium.nXi loop
    if ( Modelica.Utilities.Strings.isEqual(Medium.substanceNames[i], substanceName)) then
      ind := i;
    end if;
  end for;
  assert(ind > 0, "Mass fraction '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check sensor parameter and medium model.");
equation
  XiVec = inStream(port.Xi_outflow);
  Xi = XiVec[ind];
annotation (defaultComponentName="massFraction",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{140,44},{40,14}},
          lineColor={0,0,0},
          textString="Xi"),
        Line(points={{70,0},{100,0}}, color={0,0,127}),
        Line(points={{0,-70},{0,-100}}, color={0,127,255})}),
  Documentation(info="<html>
<p>
This component monitors the mass fraction contained in the fluid passing its port.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>", revisions="<html>
<ul>
<li>2011-12-14: Stefan Wischhusen: Initial Release.</li>
</ul>
</html>"));
end MassFractions;
