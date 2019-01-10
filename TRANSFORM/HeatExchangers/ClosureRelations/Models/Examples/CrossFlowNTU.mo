within TRANSFORM.HeatExchangers.ClosureRelations.Models.Examples;
model CrossFlowNTU

  extends TRANSFORM.Icons.Example;

  // '1' -> gas side
  // '2' -> pressurized water side

  parameter SI.Temperature T_1_inlet=300 + 273.15;
  parameter SI.Temperature T_1_outlet=100 + 273.15;
  parameter SI.SpecificHeatCapacity cp_1=1000 "Specific heat";

  parameter SI.Temperature T_2_inlet=35 + 273.15;
  parameter SI.Temperature T_2_outlet=125 + 273.15;
  parameter SI.SpecificHeatCapacity cp_2=4197;

//   parameter Boolean use_m_flow_1=false
//     "=true to for m_flow to specify flow rate for stream 1 else stream 2";
  parameter SI.MassFlowRate m_flow=1;

  parameter SI.CoefficientOfHeatTransfer U=100
    "Overall heat transfer coefficient";
//
//   replaceable model EffectivenessNTU =
//       TRANSFORM.HeatExchangers.ClosureRelations.Models.EffectivenessNTU_Relations.ConcentricTube
//                                                                                                                                       constrainedby
//     TRANSFORM.HeatExchangers.ClosureRelations.Models.EffectivenessNTU_Relations.PartialMethod
//                                                                                                                                                                                                             annotation(choicesAllMatching=true);
//
//   EffectivenessNTU effectivenessNTU(C_1=C_1,C_2=C_2);
//
//   SI.MassFlowRate m_flow_1;
//   SI.MassFlowRate m_flow_2;
//
//   SI.ThermalConductance C_1 "Heat capacity rate";
//   SI.ThermalConductance C_2 "Heat capacity rate";
//
//   SI.HeatFlowRate Q_flow_max "Maximum heat transfer rate";
//   SI.HeatFlowRate Q_flow "Actual heat transfer rate";
//   SI.Area surfaceArea "Heat transfer surface area";
//   SIadd.NonDim epsilon "Effectiveness";
//   SIadd.NonDim NTU "Number of transfer units";
//
//   //   TRANSFORM.Utilities.ErrorAnalysis.UnitTests unitTests(
//   //     x={uAdT_lm.U,uAdT_lm1.surfaceArea},
//   //     x_reference={38.1,5.178},
//   //     n=2) annotation (Placement(transformation(extent={{80,80},{100,100}})));
//   //
// protected
//   SI.Temperature T_1_hot=max(T_1_outlet, T_1_inlet);
//   SI.Temperature T_1_cold=min(T_1_outlet, T_1_inlet);
//   SI.Temperature T_2_hot=max(T_2_outlet, T_2_inlet);
//   SI.Temperature T_2_cold=min(T_2_outlet, T_2_inlet);
//
//   SI.ThermalConductance C_min=min(C_1, C_2);
//   SI.ThermalConductance C_max=max(C_1, C_2);
//
// equation
//   if use_m_flow_1 then
//     C_1 = m_flow_1*cp_1;
//     C_2 = C_1*(T_1_hot - T_1_cold)/(T_2_hot - T_2_cold);
//     m_flow_1 = m_flow;
//     m_flow_2 = C_2/cp_1;
//     Q_flow = m_flow_1*cp_1*(T_1_hot - T_1_cold);
//   else
//     C_1 = C_2*(T_2_hot - T_2_cold)/(T_1_hot - T_1_cold);
//     C_2 = m_flow_2*cp_2;
//     m_flow_1 = C_1/cp_2;
//     m_flow_2 = m_flow;
//     Q_flow = m_flow_2*cp_2*(T_2_hot - T_2_cold);
//   end if;
//
//   Q_flow_max = C_min*max(T_1_hot - T_2_cold, T_2_hot - T_1_cold);
//   effectivenessNTU.epsilon = Q_flow/Q_flow_max;
//   effectivenessNTU.NTU = U*surfaceArea/C_min;

  ClosureRelations.Models.EffectivenessNTU_Relations.Crossflow crossflow
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Source:</p>
<p>Incropera, Frank P., David P. DeWitt, Theodore L. Bergman, and Adrienne S. Lavine, eds. Fundamentals of Heat and Mass Transfer. 6. ed. Hoboken, NJ: Wiley, 2007. </p>
<p>Example 11.3</p>
</html>"));
end CrossFlowNTU;
