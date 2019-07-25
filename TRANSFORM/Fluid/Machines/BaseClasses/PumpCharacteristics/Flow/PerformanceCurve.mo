within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Flow;
model PerformanceCurve
  extends PartialFlowChar;
  parameter SI.Height head_curve[:]={0,head_nominal,2*head_nominal} "Pump head nominal operating points";
  parameter SI.VolumeFlowRate V_flow_curve[size(head_curve, 1)]={1.5*V_flow_nominal,V_flow_nominal,0}
    "Volume flow rate nominal operating points (single pump)";

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
      N/N_nominal) else 0;
  else
    V_flow =affinityLaw_flow*TRANSFORM.Math.PerformanceCurve(
      head/affinityLaw_head,
      head_curve,
      V_flow_curve,
      N/N_nominal);
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PerformanceCurve;
