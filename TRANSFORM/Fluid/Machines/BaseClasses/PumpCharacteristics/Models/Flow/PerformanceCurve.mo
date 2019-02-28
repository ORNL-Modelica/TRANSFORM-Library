within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Models.Flow;
model PerformanceCurve
  "Cubic spline of a characteristic curve of head vs. volume flow rate"
  extends PartialFlowChar;
  parameter SI.VolumeFlowRate V_flow_curve[:]={0,V_flow_nominal,1.5*
      V_flow_nominal}
    "Volume flow rate nominal operating points (single pump)";
  parameter SI.Height head_curve[size(V_flow_curve, 1)]={2*head_nominal,
      head_nominal,0} "Pump head nominal operating points";
  Real s(start=V_flow_start/unit_V_flow)
    "Curvilinear abscissa for the flow curve in parametric form (either volume flow rate or head)";
  final parameter SI.Height head_start=
      Functions.PerformanceCurve(
      V_flow_start,
      V_flow_curve,
      head_curve,
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
      TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Functions.PerformanceCurve(
      V_flow,
      V_flow_curve,
      head_curve,
      N/N_nominal) else affinityLaw*
      TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Functions.PerformanceCurve(
      0,
      V_flow_curve,
      head_curve,
      N/N_nominal) - s*unit_head, N/N_nominal*(
      TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Functions.PerformanceCurve(
      0,
      V_flow_curve,
      head_curve,
      N/N_nominal) + head_start*V_flow));
  else
    head = homotopy(affinityLaw*
      TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Functions.PerformanceCurve(
      V_flow,
      V_flow_curve,
      head_curve,
      N/N_nominal), affinityLaw*(
      TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Functions.PerformanceCurve(
      0,
      V_flow_curve,
      head_curve,
      N/N_nominal) + head_start*V_flow));
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PerformanceCurve;
