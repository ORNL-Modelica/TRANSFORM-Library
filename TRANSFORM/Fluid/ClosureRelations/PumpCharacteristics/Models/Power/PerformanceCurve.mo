within TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Power;
model PerformanceCurve   "Cubic spline of a characteristic curve of power vs. volume flow rate"
  extends PartialPowerChar;
  parameter SI.VolumeFlowRate V_flow_curve[:]={0,V_flow_nominal,1.5*
      V_flow_nominal}
    "Volume flow rate for three operating points (single pump)";
  parameter SI.Power W_curve[size(V_flow_curve, 1)]={0,W_nominal,2*W_nominal}
    "Pump head for three operating points";
equation
  W = homotopy(affinityLaw*
    TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Functions.PerformanceCurve(
          V_flow,
          V_flow_curve,
          W_curve,
          N/N_nominal), N/N_nominal*V_flow/(V_flow_start)*
    TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Functions.PerformanceCurve(
          V_flow_start,
          V_flow_curve,
          W_curve,
          N/N_nominal));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PerformanceCurve;
