within TRANSFORM.Fluid.Machines.BaseClasses.TurbineCharacteristics.Efficiency;
model QuadraticCurve_table
  "Quadratic efficiency characteristic curve, including linear extrapolation"
  extends PartialEfficiencyChar;

  parameter Real table[3,2] = [0,0.0; V_flow_nominal,1.0;1.5*V_flow_nominal,0.5] "Nominal curve. column 1 = volume flow rate, column 2 = efficiency";

  final parameter SI.VolumeFlowRate[3] V_flow_curve=table[:,1]
    "Volume flow rate for three operating points (single pump)";
  final parameter SI.Height eta_curve[size(table, 1)]=table[:,2]
    "Efficiency for three operating points";

equation

  eta = max(0.0,min(1.0,affinityLaw_efficiency*TRANSFORM.Math.quadraticCurve(
    V_flow/affinityLaw_flow,
    V_flow_curve,
    eta_curve)));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end QuadraticCurve_table;
