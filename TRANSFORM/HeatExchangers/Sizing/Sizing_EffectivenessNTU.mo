within TRANSFORM.HeatExchangers.Sizing;
model Sizing_EffectivenessNTU
  replaceable record CalcType =
      TRANSFORM.HeatExchangers.Sizing.Records.EffectivenessNTU_CalcType.Option1
    constrainedby TRANSFORM.HeatExchangers.Sizing.Records.EffectivenessNTU_CalcType.PartialCalcType
    "Select variables to be calculated" annotation (choicesAllMatching=true);
  CalcType calcType
    annotation (Placement(transformation(extent={{84,84},{96,96}})));
  replaceable model EffectivenessNTU =
      TRANSFORM.HeatExchangers.ClosureRelations.Models.EffectivenessNTU_Relations.ConcentricTube
    constrainedby TRANSFORM.HeatExchangers.ClosureRelations.Models.EffectivenessNTU_Relations.PartialEffectivenessNTU
    "Select effectiveness-NTU method" annotation (choicesAllMatching=true);
  EffectivenessNTU effectivenessNTU(
    C_1=C_1,
    C_2=C_2,
    C_min=C_min,
    C_max=C_max,
    C_r=C_min/C_max,
    inputNTU=inputNTU,
    u=if inputNTU then calcType.NTU else calcType.epsilon)
    annotation (Placement(transformation(extent={{-96,84},{-84,96}})));
  parameter Boolean inputNTU=true "=true for u=NTU else u=epsilon"
    annotation (Dialog(tab="Advanced"));
  SI.ThermalConductance C_1 "Stream 1 heat capacity rate";
  SI.ThermalConductance C_2 "Stream 2 heat capacity rate";
  SI.HeatFlowRate Q_flow_max "Maximum heat transfer rate";
protected
  SI.ThermalConductance C_min=min(C_1, C_2);
  SI.ThermalConductance C_max=max(C_1, C_2);
equation
  if inputNTU then
    calcType.epsilon = effectivenessNTU.y;
  else
    calcType.NTU = effectivenessNTU.y;
  end if;
  C_1 = calcType.m_flow_1*calcType.cp_1;
  C_2 = calcType.m_flow_2*calcType.cp_2;
  calcType.Q_flow = calcType.m_flow_1*calcType.cp_1*(calcType.T_1_hot -
    calcType.T_1_cold);
  calcType.Q_flow = calcType.m_flow_2*calcType.cp_2*(calcType.T_2_hot -
    calcType.T_2_cold);
  Q_flow_max = C_min*max(calcType.T_1_hot - calcType.T_2_cold, calcType.T_2_hot -
    calcType.T_1_cold);
  calcType.epsilon = calcType.Q_flow/Q_flow_max;
  calcType.NTU = calcType.U*calcType.surfaceArea/C_min;
  annotation (
    defaultComponentName="sizing",
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Implemtation of a the effectiveness-NTU method for sizing single phase heat exchangers.</p>
<p><br>Source:</p>
<p>Incropera, Frank P., David P. DeWitt, Theodore L. Bergman, and Adrienne S. Lavine, eds. Fundamentals of Heat and Mass Transfer. 6. ed. Hoboken, NJ: Wiley, 2007. </p>
<p>Chapter 11</p>
</html>"));
end Sizing_EffectivenessNTU;
