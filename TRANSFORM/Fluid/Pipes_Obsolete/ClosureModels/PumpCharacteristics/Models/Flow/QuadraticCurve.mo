within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Models.Flow;
model QuadraticCurve
  "Quadratic flow characteristic curve, including linear extrapolation"
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Models.Flow.PartialFlowChar;

  parameter SI.VolumeFlowRate[3] V_flow_curve = {0,V_flow_nominal,1.5*V_flow_nominal}
      "Volume flow rate for three operating points (single pump)";

  parameter SI.Height[3] head_curve = {2*head_nominal,head_nominal,0} "Pump head for three operating points";

equation

    head = dp/(rho*Modelica.Constants.g_n);
    V_flow = homotopy(affinityLaw*Functions.Flow.V_flow_quadraticCurve(
    head,
    V_flow_curve,
    head_curve),V_flow_nominal);
    //V_flow = affinityLaw*Functions.Flow.V_flow_quadraticCurve(head, V_flow_curve, head_curve);

    m_flow = V_flow*rho;

    //head = affinityLaw*Functions.Flow.head_quadraticCurve(V_flow, V_flow_curve, head_curve);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end QuadraticCurve;
