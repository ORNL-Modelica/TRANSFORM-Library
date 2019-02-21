within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Models.Power;
model QuadraticCurve
  "Quadratic power characteristic curve, including linear extrapolation"
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Models.Power.PartialPowerChar;
  parameter SI.VolumeFlowRate[3] V_flow_curve = {0,V_flow_nominal,1.5*V_flow_nominal}
      "Volume flow rate for three operating points (single pump)";
  parameter SI.Power[3] W_curve = {0,W_nominal,2*W_nominal} "Pump head for three operating points";
equation
  W = TRANSFORM.Math.spliceTanh(
        affinityLaw*Functions.Power.power_quadraticCurve(V_flow, V_flow_curve, W_curve),
        affinityLaw*Functions.Power.power_quadraticCurve(0, V_flow_curve, W_curve),
        m_flow,
        0.001);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end QuadraticCurve;
