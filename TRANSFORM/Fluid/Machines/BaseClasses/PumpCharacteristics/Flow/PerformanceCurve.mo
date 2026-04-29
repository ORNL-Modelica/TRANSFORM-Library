within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Flow;
model PerformanceCurve
  "Cubic-Hermite spline of a characteristic curve V_flow = f(head), with affinity-law scaling"
  extends PartialFlowChar;
  parameter SI.Height head_curve[:]={0,head_nominal,2*head_nominal} "Pump head nominal operating points";
  parameter SI.VolumeFlowRate V_flow_curve[size(head_curve, 1)]={1.5*V_flow_nominal,V_flow_nominal,0}
    "Volume flow rate nominal operating points (single pump)";
  final parameter Real d_curve[size(head_curve, 1)]=
      TRANSFORM.Math.splineDerivatives(
      x=head_curve,
      y=V_flow_curve,
      ensureMonotonicity=TRANSFORM.Math.isMonotonic(x=V_flow_curve, strict=false))
    "Spline tangents at the support points (precomputed once for analytic derivative)";

  Real s(start=V_flow_start/unit_V_flow)
    "Curvilinear abscissa for the flow curve";

protected
  constant SI.Height unit_head=1;
  constant SI.VolumeFlowRate unit_V_flow=1;

equation
  if checkValve then
    V_flow = homotopy(if s > 0 then s else 0, s);
  else
    s = 0;
  end if;
  if checkValve then
    V_flow =if s > 0 then affinityLaw_flow*TRANSFORM.Math.PerformanceCurve(
      head/affinityLaw_head,
      head_curve,
      V_flow_curve,
      d_curve,
      N/N_nominal) else 0;
  else
    V_flow =affinityLaw_flow*TRANSFORM.Math.PerformanceCurve(
      head/affinityLaw_head,
      head_curve,
      V_flow_curve,
      d_curve,
      N/N_nominal);
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Pump flow characteristic in the <em>inverted</em> form
<code>V_flow = affinityLaw_flow * f(head/affinityLaw_head, head_curve, V_flow_curve, N/N_nominal)</code>,
solving for volumetric flow given head. The affinity laws appear on both axes: the head input is
divided by <code>(N/N_nom)&sup2;</code> to look up the curve at nominal-speed coordinates, and the
returned nominal flow is multiplied by <code>(N/N_nom)</code> to give actual flow.</p>

<p>The spline tangents <code>d_curve</code> are computed once as a <code>final parameter</code> from
<code>head_curve</code> and <code>V_flow_curve</code>, and passed explicitly to
<a href=\"modelica://TRANSFORM.Math.PerformanceCurve\">TRANSFORM.Math.PerformanceCurve</a>.
This keeps <code>splineDerivatives</code> out of the time-derivative chain and lets Dymola build
analytic Jacobians.</p>
</html>"));
end PerformanceCurve;
