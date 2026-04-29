within TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Power;
model PerformanceCurve   "Cubic spline of a characteristic curve of power vs. volume flow rate"
  extends PartialPowerChar;
  parameter SI.VolumeFlowRate V_flow_curve[:]={0,V_flow_nominal,1.5*
      V_flow_nominal}
    "Volume flow rate for three operating points (single pump)";
  parameter SI.Power W_curve[size(V_flow_curve, 1)]={0,W_nominal,2*W_nominal}
    "Pump head for three operating points";
  final parameter Real d_curve[size(V_flow_curve, 1)]=
      TRANSFORM.Math.splineDerivatives(
      x=V_flow_curve,
      y=W_curve,
      ensureMonotonicity=TRANSFORM.Math.isMonotonic(x=W_curve, strict=false))
    "Spline tangents at the support points (precomputed once for analytic derivative)";
equation
  W = homotopy(affinityLaw*
    TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Functions.PerformanceCurve(
          V_flow,
          V_flow_curve,
          W_curve,
          d_curve,
          N/N_nominal), N/N_nominal*V_flow/(V_flow_start)*
    TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Functions.PerformanceCurve(
          V_flow_start,
          V_flow_curve,
          W_curve,
          d_curve,
          N/N_nominal));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Pump shaft-power characteristic in the form
<code>W = affinityLaw * f(V_flow, V_flow_curve, W_curve, N/N_nominal)</code>, where
<code>affinityLaw = (N/N_nominal)&sup3; (diameter/diameter_nominal)&sup3;</code> as expected from the
power-affinity relation. A <code>homotopy</code> fallback gives a linear power-vs-flow expression
during initialisation.</p>

<p>The spline tangents <code>d_curve</code> are computed once as a <code>final parameter</code>
and passed to
<a href=\"modelica://TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Functions.PerformanceCurve\">Functions.PerformanceCurve</a>,
keeping <code>splineDerivatives</code> out of the time-derivative chain.</p>
</html>"));
end PerformanceCurve;
