within TRANSFORM.HeatExchangers.Sizing;
model EffectivenessNTU

  parameter SI.Temperature Ts_1[2]={373.15,573.15} "Stream 1 temperatures";
  parameter SI.SpecificHeatCapacity cp_1=1000 "Stream 1 specific heat capacity";

  parameter SI.Temperature Ts_2[2]={308.15,398.15} "Stream 2 temperatures";
  parameter SI.SpecificHeatCapacity cp_2=4197 "Stream 2 specific heat capacity";

  parameter Boolean use_m_flow_1=false
    "=true to for m_flow to specify flow rate for stream 1 else stream 2";
  parameter SI.MassFlowRate m_flow=1 "Mass flow rate of specified stream";

  parameter SI.CoefficientOfHeatTransfer U=100
    "Overall heat transfer coefficient (NTU = U*A/C_min)";

  replaceable model EffectivenessNTU =
      TRANSFORM.HeatExchangers.ClosureRelations.Models.EffectivenessNTU_Relations.ConcentricTube
    constrainedby
    TRANSFORM.HeatExchangers.ClosureRelations.Models.EffectivenessNTU_Relations.PartialEffectivenessNTU
    annotation (choicesAllMatching=true);

  EffectivenessNTU effectivenessNTU(
    C_1=C_1,
    C_2=C_2,
    C_min=C_min,
    C_max=C_max,
    C_r=C_min/C_max) annotation (Placement(transformation(extent={{-96,84},{-84,96}})));

  SI.ThermalConductance C_1 "Stream 1 heat capacity rate";
  SI.ThermalConductance C_2 "Stream 2 heat capacity rate";

  SI.HeatFlowRate Q_flow_max "Maximum heat transfer rate";
  SI.HeatFlowRate Q_flow "Actual heat transfer rate";
  SI.Area surfaceArea "Heat transfer surface area";

protected
  SI.MassFlowRate m_flow_1;
  SI.MassFlowRate m_flow_2;

  SI.Temperature T_1_hot=max(Ts_1);
  SI.Temperature T_1_cold=min(Ts_1);
  SI.Temperature T_2_hot=max(Ts_2);
  SI.Temperature T_2_cold=min(Ts_2);

  SI.ThermalConductance C_min=min(C_1, C_2);
  SI.ThermalConductance C_max=max(C_1, C_2);

equation
  if use_m_flow_1 then
    C_1 = m_flow_1*cp_1;
    C_2 = C_1*(T_1_hot - T_1_cold)/(T_2_hot - T_2_cold);
    m_flow_1 = m_flow;
    m_flow_2 = C_2/cp_1;
    Q_flow = m_flow_1*cp_1*(T_1_hot - T_1_cold);
  else
    C_1 = C_2*(T_2_hot - T_2_cold)/(T_1_hot - T_1_cold);
    C_2 = m_flow_2*cp_2;
    m_flow_1 = C_1/cp_2;
    m_flow_2 = m_flow;
    Q_flow = m_flow_2*cp_2*(T_2_hot - T_2_cold);
  end if;

  Q_flow_max = C_min*max(T_1_hot - T_2_cold, T_2_hot - T_1_cold);
  effectivenessNTU.epsilon = Q_flow/Q_flow_max;
  effectivenessNTU.NTU = U*surfaceArea/C_min;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end EffectivenessNTU;
