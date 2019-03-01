within TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Models.Head;
model PerformanceCurvenew
  "Cubic spline of a characteristic curve of head vs. volume flow rate"
  extends PartialFlowChar2;
  parameter SI.Height head_curve[:]={2*head_nominal,
      head_nominal,0} "Pump head nominal operating points";
  parameter SI.VolumeFlowRate V_flow_curve[size(head_curve, 1)]={0,V_flow_nominal,1.5*
      V_flow_nominal}
    "Volume flow rate nominal operating points (single pump)";

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
            N/N_nominal) else 0;
  else
    V_flow = affinityLaw_flow*
      TRANSFORM.Fluid.ClosureRelations.PumpCharacteristics.Functions.PerformanceCurve(
            head/affinityLaw_head,
            head_curve,
            V_flow_curve,
            N/N_nominal);
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PerformanceCurvenew;
