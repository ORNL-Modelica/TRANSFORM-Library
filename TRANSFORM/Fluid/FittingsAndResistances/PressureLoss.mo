within TRANSFORM.Fluid.FittingsAndResistances;
model PressureLoss
  extends BaseClasses.PartialResistance;
  input SI.PressureDifference dp0 "Pressure loss (port_a.p-port_b.p)" annotation(Dialog(group="Inputs"));
equation
  dp = dp0;
  annotation (defaultComponentName="resistance",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-30,-50},{30,-70}},
          lineColor={0,0,0},
          textString="Set R")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end PressureLoss;
