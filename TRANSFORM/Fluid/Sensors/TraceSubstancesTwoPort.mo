within TRANSFORM.Fluid.Sensors;
model TraceSubstancesTwoPort "Ideal two port sensor for trace substance"
  extends BaseClasses.PartialTwoPortSensor;
  extends BaseClasses.PartialMultiSensor_1values(final var=C,
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.PrefixMultipliers.to_none
      constrainedby TRANSFORM.Units.Conversions.Functions.PrefixMultipliers.BaseClasses.to);
  Modelica.Blocks.Interfaces.RealOutput C
    "Trace substance of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,36})));
  parameter String substanceName = "CO2" "Name of trace substance";
protected
  parameter Integer ind(fixed=false)
    "Index of species in vector of auxiliary substances";
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
  if allowFlowReversal then
     C = Modelica.Fluid.Utilities.regStep(port_a.m_flow, port_b.C_outflow[ind], port_a.C_outflow[ind], m_flow_small);
  else
     C = port_b.C_outflow[ind];
  end if;
  annotation (
    defaultComponentName="sensor_C",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{78,54},{-18,25}},
          lineColor={0,0,0},
          textString="C"),
        Line(points={{-100,0},{-50,0}}, color={0,128,255}),
        Line(points={{50,0},{100,0}}, color={0,128,255})}),
    Documentation(info="<html>
<p>
This component monitors the fluid flowing from port_a to port_b.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end TraceSubstancesTwoPort;
