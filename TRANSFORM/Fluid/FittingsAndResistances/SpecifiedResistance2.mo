within TRANSFORM.Fluid.FittingsAndResistances;
model SpecifiedResistance2
  extends BaseClasses.PartialResistance;
  input Units.HydraulicResistance R "Hydraulic resistance" annotation(Dialog(group="Inputs"));
equation
  port_a.m_flow*port_a.m_flow*R = port_a.p-port_b.p;
  annotation (defaultComponentName="resistance",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-30,-50},{30,-70}},
          lineColor={0,0,0},
          textString="Set R")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end SpecifiedResistance2;
