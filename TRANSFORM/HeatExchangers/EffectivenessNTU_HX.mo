within TRANSFORM.HeatExchangers;
model EffectivenessNTU_HX

extends TRANSFORM.Icons.UnderConstruction;

  parameter SI.Temperature T_1_hot=523.15 "Hot temperature" annotation(Dialog(group="Stream 1"));
  parameter SI.Temperature T_1_cold "Cold temperature" annotation(Dialog(group="Stream 1",enable=false));
  parameter SI.MassFlowRate m_flow_1=1.5 "Mass flow rate of specified stream" annotation(Dialog(group="Stream 1"));
  parameter SI.SpecificHeatCapacity cp_1=1000 "Specific heat capacity" annotation(Dialog(group="Stream 1"));

  parameter SI.Temperature T_2_hot "Stream 2 outlet temperature" annotation(Dialog(group="Stream 2",enable=false));
  parameter SI.Temperature T_2_cold=308.15 "Stream 2 inlet temperature" annotation(Dialog(group="Stream 2"));
  parameter SI.MassFlowRate m_flow_2=1 "Mass flow rate of specified stream" annotation(Dialog(group="Stream 2"));
  parameter SI.SpecificHeatCapacity cp_2=4197 "Stream 2 specific heat capacity" annotation(Dialog(group="Stream 2"));

  SI.HeatFlowRate Q_flow "Actual heat transfer rate";
  parameter SI.CoefficientOfHeatTransfer U=100
    "Overall heat transfer coefficient (NTU = U*A/C_min)" annotation(Dialog(group="Overall"));
  parameter SI.Area surfaceArea=40 "Heat transfer surface area" annotation(Dialog(group="Overall"));
  parameter SIadd.NonDim epsilon "Effectiveness" annotation(Dialog(group="Overall"));
  parameter SIadd.NonDim NTU "Number of transfer units" annotation(Dialog(group="Overall"));


equation

  Q_flow = epsilon*U*surfaceArea/NTU*(T_1_hot - T_1_cold);


  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end EffectivenessNTU_HX;
