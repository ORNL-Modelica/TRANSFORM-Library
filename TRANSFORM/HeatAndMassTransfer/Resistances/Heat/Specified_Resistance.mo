within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model Specified_Resistance "Specify Resistance"

  extends BaseClasses.PartialResistance;

  input SI.ThermalResistance R_val "Thermal resistance" annotation(Dialog(group="Input Variables"));

equation

  R = R_val;

  annotation (defaultComponentName="generic",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-30,-50},{30,-70}},
          lineColor={0,0,0},
          textString="Set R")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end Specified_Resistance;
