within TRANSFORM.Fluid.Sensors;
model TraceSubstances "Ideal one port trace substances sensor"
  extends BaseClasses.PartialAbsoluteSensor;
  extends BaseClasses.PartialMultiSensor_1values(final var=C,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.PrefixMultipliers.to_none
      constrainedby
      TRANSFORM.Units.Conversions.Functions.PrefixMultipliers.BaseClasses.to);
  parameter String substanceName = "CO2" "Name of trace substance";

  Modelica.Blocks.Interfaces.RealOutput C "Trace substance in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{50,-10},{70,10}})));

protected
  parameter Integer ind(fixed=false)
    "Index of species in vector of auxiliary substances";
  Medium.ExtraProperty CVec[Medium.nC](
      quantity=Medium.extraPropertiesNames)
    "Trace substances vector, needed because indexed argument for the operator inStream is not supported";
initial algorithm
  ind:= -1;
  for i in 1:Medium.nC loop
    if ( Modelica.Utilities.Strings.isEqual(Medium.extraPropertiesNames[i], substanceName)) then
      ind := i;
    end if;
  end for;
  assert(ind > 0, "Trace substance '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check sensor parameter and medium model.");
equation
  CVec = inStream(port.C_outflow);
  C = CVec[ind];
annotation (defaultComponentName="traceSubstance",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-20,14},{-120,-16}},
          lineColor={0,0,0},
          textString="C"),
        Line(points={{0,-26},{0,-100}}, color={0,127,255})}),
  Documentation(info="<html>
<p>
This component monitors the trace substances contained in the fluid passing its port.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end TraceSubstances;
