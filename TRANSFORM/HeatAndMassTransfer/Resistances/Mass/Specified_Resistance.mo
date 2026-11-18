within TRANSFORM.HeatAndMassTransfer.Resistances.Mass;
model Specified_Resistance "Specified mass transfer resistance model"
  extends BaseClasses.PartialResistance;
  input SItf.DiffusionResistance R_val[nC] "Diffusion resistance" annotation(Dialog(group="Inputs"));
equation
  R = R_val;
  annotation (defaultComponentName="generic",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-30,-50},{30,-70}},
          textColor={0,0,0},
          textString="Set R")}),
        Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Mass transfer resistance using a user defined mass transfer resistance.</p>
</html>"));
end Specified_Resistance;
