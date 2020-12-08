within TRANSFORM.Fluid.Pipes_Obsolete.ClosureModels.PumpCharacteristics.Functions.Head.Examples;
model head_quadraticCurve_Test
  extends Icons.Example;
  constant SI.VolumeFlowRate V_flow_nominal = 1 "Volume flow rate";
  constant SI.Density rho_nominal = 1000 "Nominal Density";
  constant SI.PressureDifference dp_nominal = 1e5 "Nominal pressure loss";
  constant SI.Height head_nominal = dp_nominal/(rho_nominal*Modelica.Constants.g_n) "Head at nominal conditions";
  constant SI.VolumeFlowRate[3] V_flow_curve = {0,V_flow_nominal,1.5*V_flow_nominal}
      "Volume flow rate for three operating points (single pump)";
  constant SI.Height[3] head_curve = {2*head_nominal,head_nominal,0} "Pump head for three operating points";
  SI.Height head "Pump pressure head";
  Modelica.Blocks.Sources.Sine V_flow(
    amplitude=2,
    f=1/10,
    startTime=10) annotation (Placement(transformation(extent={{
            -10,-10},{10,10}})));
equation
  head = head_quadraticCurve(V_flow.y, V_flow_curve, head_curve);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100));
end head_quadraticCurve_Test;
