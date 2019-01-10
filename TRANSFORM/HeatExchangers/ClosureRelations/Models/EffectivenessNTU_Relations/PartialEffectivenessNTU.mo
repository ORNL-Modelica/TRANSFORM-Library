within TRANSFORM.HeatExchangers.ClosureRelations.Models.EffectivenessNTU_Relations;
partial model PartialEffectivenessNTU

  input SI.ThermalConductance C_1 "Heat capacity rate" annotation(Dialog(tab="Internal Interface",group="Inputs"));
  input SI.ThermalConductance C_2 "Heat capacity rate" annotation(Dialog(tab="Internal Interface",group="Inputs"));
  input SI.ThermalConductance C_min=min(C_1, C_2) annotation(Dialog(tab="Internal Interface",group="Inputs"));
  input SI.ThermalConductance C_max=max(C_1, C_2) annotation(Dialog(tab="Internal Interface",group="Inputs"));
  input SI.ThermalConductance C_r=C_min/C_max annotation(Dialog(tab="Internal Interface",group="Inputs"));

  SIadd.NonDim epsilon(start = 0.5) "Effectiveness";
  SIadd.NonDim NTU(start = 1) "Number of transfer units";

  annotation (defaultComponentName="effectivenessNTU",
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This partial model requires the modeler to define an equation for epsilon or NTU at a higher abstracted level. As such, the model fails to check alone. See examples for details.</p>
</html>"));
end PartialEffectivenessNTU;
