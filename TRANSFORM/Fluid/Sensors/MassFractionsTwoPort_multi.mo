within TRANSFORM.Fluid.Sensors;
model MassFractionsTwoPort_multi "Ideal two port sensor for species"

  parameter Integer iDisplay = 1 "Index of trace substance to display (for GUI only)";

  extends BaseClasses.PartialTwoPortSensor;
  extends BaseClasses.PartialMultiSensor_1values(final var=if Medium.nXi < 1 then 0 else Xi[iDisplay],
      redeclare replaceable function iconUnit =
        TRANSFORM.Units.Conversions.Functions.PrefixMultipliers.to_none
      constrainedby
      TRANSFORM.Units.Conversions.Functions.PrefixMultipliers.BaseClasses.to);
  Modelica.Blocks.Interfaces.RealOutput[Medium.nXi] Xi
    "Mass fraction of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,36})));

equation

  if allowFlowReversal then
    for i in 1:Medium.nXi loop
     Xi[i] = Modelica.Fluid.Utilities.regStep(port_a.m_flow, port_b.Xi_outflow[i], port_a.Xi_outflow[i], m_flow_small);
    end for;
  else
    for i in 1:Medium.nXi loop
     Xi[i] = port_b.Xi_outflow[i];
    end for;
  end if;

  annotation (
    defaultComponentName="sensor_Xi",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{84,54},{-12,25}},
          lineColor={0,0,0},
          textString="Xis"),
        Line(points={{-100,0},{-50,0}}, color={0,128,255}),
        Line(points={{50,0},{100,0}}, color={0,128,255})}),
    Documentation(info="<html>
<p>
This component monitors the fluid flowing from port_a to port_b.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end MassFractionsTwoPort_multi;
