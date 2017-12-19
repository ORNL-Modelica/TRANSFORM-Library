within TRANSFORM.Fluid.Sensors;
model TraceSubstancesTwoPort_multi
  "Ideal two port sensor for trace substance"
  extends BaseClasses.PartialTwoPortSensor;
  extends Modelica.Icons.RotationalSensor;
  Modelica.Blocks.Interfaces.RealOutput[Medium.nC] C
    "Trace substance of the passing fluid"
    annotation (Placement(transformation(
        origin={0,110},
        extent={{10,-10},{-10,10}},
        rotation=270)));

equation
  if allowFlowReversal then
    for i in 1:Medium.nC loop
     C[i] = Modelica.Fluid.Utilities.regStep(port_a.m_flow, port_b.C_outflow[i], port_a.C_outflow[i], m_flow_small);
    end for;
  else
    for i in 1:Medium.nC loop
     C[i] = port_b.C_outflow[i];
    end for;
  end if;
annotation (defaultComponentName="traceSubstance",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{10,104},{-72,74}},
          lineColor={0,0,0},
          textString="C"),
        Line(points={{0,100},{0,70}}, color={0,0,127}),
        Line(points={{-100,0},{-70,0}}, color={0,128,255}),
        Line(points={{70,0},{100,0}}, color={0,128,255})}),
  Documentation(info="<html>
<p>
This component monitors the trace substance of the passing fluid.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
</html>"));
end TraceSubstancesTwoPort_multi;
