within TRANSFORM.HeatAndMassTransfer.Resistances.Mass;
model Specified_Resistance "Specify Resistance"

  extends BaseClasses.PartialResistance;

  input Units.DiffusionResistance R_val[nC] "Diffusion resistance" annotation(Dialog(group="Inputs"));

equation

  R = R_val;

  annotation (defaultComponentName="generic",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-30,-50},{30,-70}},
          lineColor={0,0,0},
          textString="Set R")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end Specified_Resistance;
