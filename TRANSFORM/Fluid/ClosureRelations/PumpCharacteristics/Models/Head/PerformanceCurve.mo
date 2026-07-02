within TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Head;
model PerformanceCurve
  "Cubic spline of a characteristic curve of head vs. volume flow rate"
  extends PartialFlowChar;
  parameter SI.VolumeFlowRate V_flow_curve[:]={0,V_flow_nominal,1.5*
      V_flow_nominal}
    "Volume flow rate nominal operating points (single pump)";
  parameter SI.Height head_curve[size(V_flow_curve, 1)]={2*head_nominal,
      head_nominal,0} "Pump head nominal operating points";
  final parameter Real d_curve[size(V_flow_curve, 1)]=
      TRANSFORM.Math.splineDerivatives(
      x=V_flow_curve,
      y=head_curve,
      ensureMonotonicity=TRANSFORM.Math.isMonotonic(x=head_curve, strict=false))
    "Spline tangents at the support points (precomputed once for analytic derivative)";
  Real s(start=V_flow_start/unit_V_flow)
    "Curvilinear abscissa for the flow curve in parametric form (either volume flow rate or head)";
  final parameter SI.Height head_start=
      Functions.PerformanceCurve(
      V_flow_start,
      V_flow_curve,
      head_curve,
      d_curve,
      N_nominal/N_nominal) "Used for simplified initialization model";
protected
  constant SI.Height unit_head=1;
  constant SI.VolumeFlowRate unit_V_flow=1;
equation
  if checkValve then
    V_flow = homotopy(if s > 0 then s else 0, s);
    //V_flow = homotopy(TRANSFORM.Math.spliceTanh(V_flow,0,s,0.001),s);
  else
    s = 0;
  end if;
  if checkValve then
    head = homotopy(if s > 0 then affinityLaw*
      TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Functions.PerformanceCurve(
            V_flow,
            V_flow_curve,
            head_curve,
            d_curve,
            N/N_nominal) else affinityLaw*
      TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Functions.PerformanceCurve(
            0,
            V_flow_curve,
            head_curve,
            d_curve,
            N/N_nominal) - s*unit_head, N/N_nominal*(
      TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Functions.PerformanceCurve(
            0,
            V_flow_curve,
            head_curve,
            d_curve,
            N/N_nominal) + head_start*V_flow));
  else
    head = homotopy(affinityLaw*
      TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Functions.PerformanceCurve(
            V_flow,
            V_flow_curve,
            head_curve,
            d_curve,
            N/N_nominal), affinityLaw*(
      TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Functions.PerformanceCurve(
            0,
            V_flow_curve,
            head_curve,
            d_curve,
            N/N_nominal) + head_start*V_flow));
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Pump head characteristic in the form
<code>head = affinityLaw * f(V_flow, V_flow_curve, head_curve, N/N_nominal)</code>, solving for
head given volumetric flow. The affinity-law factor used here is
<code>affinityLaw = (N/N_nominal)&sup2; (diameter/diameter_nominal)&sup2;</code>, applied to the
head output only.</p>

<p>If <code>checkValve = true</code>, a parametric <code>s</code> abscissa with a <code>homotopy</code>
transition is used so that reverse flow is suppressed below the closing point of the curve. The
homotopy fallback expression at <code>s = 0</code> uses <code>head_start</code>, evaluated once at
parameter time from the same curve.</p>

<p>The spline tangents <code>d_curve</code> are computed once as a <code>final parameter</code>
and passed to
<a href=\"modelica://TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Functions.PerformanceCurve\">Functions.PerformanceCurve</a>
on every call (including the <code>head_start</code> parameter evaluation). This keeps
<code>splineDerivatives</code> out of the time-derivative chain and enables analytic Jacobians.</p>
</html>"));
end PerformanceCurve;
