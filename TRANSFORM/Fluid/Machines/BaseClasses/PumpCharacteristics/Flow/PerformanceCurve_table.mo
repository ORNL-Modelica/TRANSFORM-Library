within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Flow;
model PerformanceCurve_table
  "Same as PerformanceCurve, but the (head, V_flow) support points are entered as a 2-column table"
  extends PartialFlowChar;
  parameter Real table[:,2] = [0,1.5*V_flow_nominal; head_nominal,V_flow_nominal;
        2*head_nominal,0] "Nominal curve. column 1 = head, column 2 = volume flow rate";
  final parameter SI.Height head_curve[size(table, 1)]=table[:,1] "Pump head nominal operating points";
  final parameter SI.VolumeFlowRate V_flow_curve[size(table, 1)]=table[:,2]
    "Volume flow rate nominal operating points (single pump)";
  final parameter Real d_curve[size(table, 1)]=
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
<p>Identical to
<a href=\"modelica://TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Flow.PerformanceCurve\">PerformanceCurve</a>
except that the support points are supplied as a single <code>table[:,2]</code> parameter
(column 1 = head, column 2 = volumetric flow rate) rather than two separate vector parameters.
See that model for the formulation and analytic-derivative behaviour.</p>
</html>"));
end PerformanceCurve_table;
