within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Functions.Power.Examples;
model power_quadraticCurve_Test
  extends Icons.Example;
  constant SI.VolumeFlowRate V_flow_nominal = 1 "Volume flow rate";
  constant SI.PressureDifference dp_nominal = 1e5 "Nominal pressure loss";
  constant SI.Power W_nominal = V_flow_nominal*dp_nominal "Power consumption at nominal conditions";
  constant SI.VolumeFlowRate[3] V_flow_curve = {0,V_flow_nominal,1.5*V_flow_nominal}
      "Volume flow rate for three operating points (single pump)";
  constant SI.Power[3] W_curve = {0,W_nominal,2*W_nominal} "Pump head for three operating points";
  SI.Power W "Pump pressure head";
  Real[3] cs "Curve coefficients";
  Modelica.Blocks.Sources.Sine V_flow(
    amplitude=2,
    f=1/10,
    startTime=10) annotation (Placement(transformation(extent={{
            -10,-10},{10,10}})));
equation
  (W,cs) = Power.power_quadraticCurve(
    V_flow.y,
    V_flow_curve,
    W_curve);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100));
end power_quadraticCurve_Test;
