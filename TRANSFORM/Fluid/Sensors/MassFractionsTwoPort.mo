within TRANSFORM.Fluid.Sensors;
model MassFractionsTwoPort "Ideal two port sensor for mass fraction"
  extends TRANSFORM.Fluid.Sensors.BaseClasses.PartialTwoPortSensor;
  extends BaseClasses.PartialMultiSensor_1values(final var=Xi,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.PrefixMultipliers.to_none
      constrainedby
      TRANSFORM.Units.Conversions.Functions.PrefixMultipliers.BaseClasses.to);
  Modelica.Blocks.Interfaces.RealOutput Xi "Mass fraction in port medium"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=90,
        origin={0,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,36})));
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
  assert(ind > 0, "Mass-Specific value '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check sensor parameter and medium model.");
equation
  if allowFlowReversal then
     Xi = Modelica.Fluid.Utilities.regStep(port_a.m_flow, port_b.Xi_outflow[ind], port_a.Xi_outflow[ind], m_flow_small);
  else
     Xi = port_b.Xi_outflow[ind];
  end if;
  annotation (
    defaultComponentName="sensor_Xi",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{80,56},{-16,27}},
          lineColor={0,0,0},
          textString="Xi"),
        Line(points={{-100,0},{-50,0}}, color={0,128,255}),
        Line(points={{50,0},{100,0}}, color={0,128,255})}),
    Documentation(info="<html>
<p>
This component monitors the fluid flowing from port_a to port_b.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end MassFractionsTwoPort;
