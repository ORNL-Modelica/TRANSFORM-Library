within TRANSFORM.HeatAndMassTransfer.Resistances.Heat;
model Specified_Resistance "Specified thermal resistance model"
  extends BaseClasses.PartialResistance;
  input SI.ThermalResistance R_val "Thermal resistance" annotation(Dialog(group="Inputs"));
equation
  R = R_val;
  annotation (defaultComponentName="generic",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-30,-50},{30,-70}},
          textColor={0,0,0},
          textString="Set R")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Thermal resistance with a value <code>R_val</code> that the user gives, for a resistance that no other class in this package computes.</p>
</html>"));
end Specified_Resistance;
