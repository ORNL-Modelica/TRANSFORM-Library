within TRANSFORM.HeatExchangers.Sizing.Records.EffectivenessNTU_CalcType;
record Option2 "Calculate: m_flow_1, Q_flow, surfaceArea, epsilon, NTU"

  extends PartialCalcType;

  parameter SI.Temperature T_1_hot=573.15 "Hot temperature" annotation(Dialog(group="Stream 1"));
  parameter SI.Temperature T_1_cold=373.15 "Cold temperature" annotation(Dialog(group="Stream 1"));
  SI.MassFlowRate m_flow_1 "Mass flow rate of specified stream" annotation(Dialog(group="Stream 1",enable=false));
  parameter SI.SpecificHeatCapacity cp_1=1000 "Specific heat capacity" annotation(Dialog(group="Stream 1"));

  parameter SI.Temperature T_2_hot=398.15 "Stream 2 outlet temperature" annotation(Dialog(group="Stream 2"));
  parameter SI.Temperature T_2_cold=308.15 "Stream 2 inlet temperature" annotation(Dialog(group="Stream 2"));
  parameter SI.MassFlowRate m_flow_2=1 "Mass flow rate of specified stream" annotation(Dialog(group="Stream 2"));
  parameter SI.SpecificHeatCapacity cp_2=4197 "Stream 2 specific heat capacity" annotation(Dialog(group="Stream 2"));

  SI.HeatFlowRate Q_flow "Actual heat transfer rate" annotation(Dialog(group="Overall",enable=false));
  parameter SI.CoefficientOfHeatTransfer U=100
    "Overall heat transfer coefficient (NTU = U*A/C_min)" annotation(Dialog(group="Overall"));
  SI.Area surfaceArea "Heat transfer surface area" annotation(Dialog(group="Overall",enable=false));
  SIadd.NonDim epsilon "Effectiveness" annotation(Dialog(group="Overall",enable=false));
  SIadd.NonDim NTU "Number of transfer units" annotation(Dialog(group="Overall",enable=false));

  annotation (defaultComponentName="calcType",Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Option2;
