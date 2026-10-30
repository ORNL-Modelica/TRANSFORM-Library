within TRANSFORM.HeatExchangers.ClosureRelations.Models.EffectivenessNTU_Relations;
partial model PartialEffectivenessNTU
  input SI.ThermalConductance C_1 "Heat capacity rate"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.ThermalConductance C_2 "Heat capacity rate"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.ThermalConductance C_min=min(C_1, C_2)
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SI.ThermalConductance C_max=max(C_1, C_2)
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SIadd.NonDim C_r=C_min/C_max
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  input SIadd.NonDim u "Input variable: epsilon or NTU. See inputNTU"
    annotation (Dialog(tab="Internal Interface", group="Inputs"));
  parameter Boolean inputNTU=true "=true for u=NTU else u=epsilon"
    annotation (Dialog(tab="Internal Interface"));
  SIadd.NonDim epsilon "Effectiveness";
  SIadd.NonDim NTU "Number of transfer units";
  SIadd.NonDim y(start=y_start);
  parameter SIadd.NonDim y_start=1
    "Initial value for non-input (i.e., if u=NTU than y=epsilon"
    annotation (Dialog(tab="Initialization"));
equation
  if inputNTU then
    u = NTU;
    y = epsilon;
  else
    u = epsilon;
    y = NTU;
  end if;
  annotation (
    defaultComponentName="effectivenessNTU",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
</html>"));
end PartialEffectivenessNTU;
