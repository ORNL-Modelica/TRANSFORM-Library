within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Functions.Efficiency.Examples;
model eta_quadraticCurve_Test
  extends Icons.Example;

  constant SI.VolumeFlowRate V_flow_nominal = 1 "Volume flow rate";
  constant SI.VolumeFlowRate[3] V_flow_curve = {0,V_flow_nominal,1.5*V_flow_nominal}
      "Volume flow rate for three operating points (single pump)";

  constant SI.Efficiency[3] eta_curve = {0,1.0,0.5} "Pump efficiency for three operating points";

  SI.Efficiency eta "Pump efficiency";

  Modelica.Blocks.Sources.Sine V_flow(
    amplitude=2,
    freqHz=1/10,
    startTime=10)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  eta = Efficiency.eta_quadraticCurve(
    V_flow.y,
    V_flow_curve,
    eta_curve);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100));
end eta_quadraticCurve_Test;
