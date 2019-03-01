within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Models.Efficiency;
model QuadraticCurve
  "Quadratic efficiency characteristic curve, including linear extrapolation"
  extends PartialEfficiencyChar;

  parameter SI.VolumeFlowRate[3] V_flow_curve={0,V_flow_nominal,1.5*
      V_flow_nominal}
    "Volume flow rate for three operating points (single pump)";
  parameter SI.Height[3] eta_curve={0.0,1.0,0.5}
    "Pump head for three operating points";

equation

  eta = max(0.0,min(1.0,affinityLaw_efficiency*TRANSFORM.Math.quadraticCurve(
    V_flow/affinityLaw_flow,
    V_flow_curve,
    eta_curve)));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end QuadraticCurve;
