within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Models.Efficiency;
model QuadraticCurve
  "Quadratic efficiency characteristic curve, including linear extrapolation"
  extends
    TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Models.Efficiency.PartialEfficiencyChar;

  parameter SI.VolumeFlowRate[3] V_flow_curve = {0,V_flow_nominal,1.5*V_flow_nominal}
      "Volume flow rate for three operating points (single pump)";

  parameter SI.Height[3] eta_curve = {0.0,1.0,0.5} "Pump head for three operating points";

equation

    //eta = homotopy(affinityLaw*Functions.Flow.head_quadraticCurve(V_flow, V_flow_curve, eta_curve),
    //dp_start/(rho_start*Modelica.Constants.g_n));
    eta = Functions.Head.head_quadraticCurve(V_flow, V_flow_curve, eta_curve);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end QuadraticCurve;
