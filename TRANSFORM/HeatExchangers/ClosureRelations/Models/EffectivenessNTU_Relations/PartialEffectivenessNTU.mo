within TRANSFORM.HeatExchangers.ClosureRelations.Models.EffectivenessNTU_Relations;
partial model PartialEffectivenessNTU

  parameter SI.Temperature T_1_inlet=300 + 273.15;
  parameter SI.Temperature T_1_outlet=100 + 273.15;
  parameter SI.SpecificHeatCapacity cp_1=1000 "Specific heat";

  parameter SI.Temperature T_2_inlet=35 + 273.15;
  parameter SI.Temperature T_2_outlet=125 + 273.15;
  parameter SI.SpecificHeatCapacity cp_2=4197;

  parameter Boolean use_m_flow_1=false
    "=true to for m_flow to specify flow rate for stream 1 else stream 2";
  parameter SI.MassFlowRate m_flow=1;

  parameter SI.CoefficientOfHeatTransfer U=100
    "Overall heat transfer coefficient";

  SI.MassFlowRate m_flow_1;
  SI.MassFlowRate m_flow_2;

  SI.ThermalConductance C_1 "Heat capacity rate";
  SI.ThermalConductance C_2 "Heat capacity rate";

//   SI.HeatFlowRate Q_flow_max "Maximum heat transfer rate";
//   SI.HeatFlowRate Q_flow "Actual heat transfer rate";
//   SI.Area surfaceArea "Heat transfer surface area";
  SIadd.NonDim epsilon(start = 0.5) "Effectiveness";
  SIadd.NonDim NTU(start = 1) "Number of transfer units";
  SIadd.NonDim C_r=C_min/C_max "Heat capacity rate ratio";
protected
  input SI.Temperature T_1_hot=max(T_1_outlet, T_1_inlet) annotation(Dialog(tab="Internal Interface",group="Inputs"));
  input SI.Temperature T_1_cold=min(T_1_outlet, T_1_inlet) annotation(Dialog(tab="Internal Interface",group="Inputs"));
  input SI.Temperature T_2_hot=max(T_2_outlet, T_2_inlet) annotation(Dialog(tab="Internal Interface",group="Inputs"));
  input SI.Temperature T_2_cold=min(T_2_outlet, T_2_inlet) annotation(Dialog(tab="Internal Interface",group="Inputs"));

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

//   Q_flow_max = C_min*max(T_1_hot - T_2_cold, T_2_hot - T_1_cold);
//   epsilon = Q_flow/Q_flow_max;
//   NTU = U*surfaceArea/C_min;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialEffectivenessNTU;
