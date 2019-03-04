within TRANSFORM.Fluid.Machines.BaseClasses.TurbineCharacteristics.Power;
model PerformanceCurve   "Cubic spline of a characteristic curve of power vs. volume flow rate"
  extends PartialPowerChar;

  parameter SI.VolumeFlowRate V_flow_curve[:]={0,V_flow_nominal,1.5*
      V_flow_nominal} "Volume flow rate operating points (single pump)";
  parameter SI.Power W_curve[size(V_flow_curve, 1)]={0,W_nominal,2*W_nominal}
    "Pump head operating points";

equation
  W =affinityLaw_power*Math.PerformanceCurve(
    V_flow/affinityLaw_flow,
    V_flow_curve,
    W_curve,
    N/N_nominal);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PerformanceCurve;
