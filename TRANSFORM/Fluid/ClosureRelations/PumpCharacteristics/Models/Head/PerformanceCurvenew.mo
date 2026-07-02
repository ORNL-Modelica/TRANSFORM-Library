within TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Head;
model PerformanceCurvenew
  "Cubic spline of a characteristic curve of head vs. volume flow rate"
  extends PartialFlowChar2;
  parameter SI.Height head_curve[:]={2*head_nominal,
      head_nominal,0} "Pump head nominal operating points";
  parameter SI.VolumeFlowRate V_flow_curve[size(head_curve, 1)]={0,V_flow_nominal,1.5*
      V_flow_nominal}
    "Volume flow rate nominal operating points (single pump)";
  final parameter Real d_curve[size(head_curve, 1)]=
      TRANSFORM.Math.splineDerivatives(
      x=head_curve,
      y=V_flow_curve,
      ensureMonotonicity=TRANSFORM.Math.isMonotonic(x=V_flow_curve, strict=false))
    "Spline tangents at the support points (precomputed once for analytic derivative)";

  Real s(start=head_start/unit_head)
    "Curvilinear abscissa for the flow curve in parametric form (either volume flow rate or head)";
//   final parameter SI.Height head_start=
//       Functions.PerformanceCurve(
//       V_flow_start,
//       V_flow_curve,
//       head_curve,
//       N_nominal/N_nominal) "Used for simplified initialization model";
protected
  constant SI.Height unit_head=1;
  constant SI.VolumeFlowRate unit_V_flow=1;

equation
  if checkValve then
    head = homotopy(if s > 0 then s else 0, s);
    //V_flow = homotopy(TRANSFORM.Math.spliceTanh(V_flow,0,s,0.001),s);
  else
    s = 0;
  end if;
  if checkValve then
    V_flow = if s > 0 then affinityLaw_flow*
      TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Functions.PerformanceCurve(
            head/affinityLaw_head,
            head_curve,
            V_flow_curve,
            d_curve,
            N/N_nominal) else 0;
  else
    V_flow = affinityLaw_flow*
      TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Functions.PerformanceCurve(
            head/affinityLaw_head,
            head_curve,
            V_flow_curve,
            d_curve,
            N/N_nominal);
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b>Status:</b> in-progress / unused. Not referenced from any model or example as of this writing
&mdash; the only example named like a test for it (<code>QuadraticCurve_Testnew</code>) actually
redeclares the regular <code>PerformanceCurve</code> rather than this variant.</p>

<p><b>Intent.</b> This variant rewrites the head characteristic in the inverted form
<code>V_flow = affinityLaw_flow * f(head/affinityLaw_head, head_curve, V_flow_curve, N/N_nominal)</code>
&mdash; treating <code>head</code> as an input and <code>V_flow</code> as the unknown, and applying
the pump affinity laws on <em>both</em> axes
(<code>affinityLaw_flow = (N/N_nom)(d/d_nom)</code>,
<code>affinityLaw_head = (N/N_nom)&sup2;(d/d_nom)&sup2;</code>) via
<a href=\"modelica://TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Head.PartialFlowChar2\">PartialFlowChar2</a>.
This matches the formulation already used by
<a href=\"modelica://TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Flow.PerformanceCurve\">Flow.PerformanceCurve</a>,
and is more correct than the original <code>PartialFlowChar</code> form which only scales the head
output by <code>(N/N_nom)&sup2;</code> and does not rescale the flow axis with speed.</p>

<p><b>What is unfinished.</b> No example exercises this variant, no upstream pump model uses it,
and the partial base <code>PartialFlowChar2</code> duplicates members from
<code>PartialCharacteristic</code> rather than extending it &mdash; so any future work would also
want to consolidate those base classes.</p>
</html>"));
end PerformanceCurvenew;
