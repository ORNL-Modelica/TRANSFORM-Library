within TRANSFORM.Controls.Examples;
model LimPID_Hysteresis_Test
  extends TRANSFORM.Icons.Example;
  LimPID_Hysteresis                       PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMin=0.3,
    Ti=600,
    Td=60)
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Modelica.Blocks.Sources.Constant setpoint(k=273.15 + 40, y(unit="K"))
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  HeatAndMassTransfer.Volumes.UnitVolume volume(
    V=1,
    d(displayUnit="kg/m3") = 1,
    cp=1e6,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=313.15)
    annotation (Placement(transformation(extent={{38,-20},{58,0}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.Temperature boundary(use_port=
        true) annotation (Placement(transformation(extent={{0,10},{20,30}})));
  HeatAndMassTransfer.Resistances.Heat.Plane conduction(
    L=1,
    crossArea=1,
    lambda=20) annotation (Placement(transformation(extent={{38,10},{58,30}})));
  Modelica.Blocks.Math.Gain gain(k=2000)
    annotation (Placement(transformation(extent={{-12,-30},{8,-10}})));
  HeatAndMassTransfer.Sensors.Temperature sensor
    annotation (Placement(transformation(extent={{70,-20},{90,0}})));
  HeatAndMassTransfer.BoundaryConditions.Heat.HeatFlow     Q_flow(use_port=true)
    annotation (Placement(transformation(extent={{16,-30},{36,-10}})));
  Modelica.Blocks.Sources.Sine sine(
    f=1/86400,
    offset=273.15,
    amplitude=20,
    y(unit="K"),
    phase=-1.5707963267949)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Utilities.ErrorAnalysis.UnitTests           unitTests(n=2, x={PID.y,sensor.T})
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  connect(setpoint.y, PID.u_s)
    annotation (Line(points={{-59,-20},{-42,-20}}, color={0,0,127}));
  connect(boundary.port, conduction.port_a)
    annotation (Line(points={{20,20},{41,20}}, color={191,0,0}));
  connect(conduction.port_b, volume.port) annotation (Line(points={{55,20},{66,
          20},{66,-20},{48,-20}}, color={191,0,0}));
  connect(PID.y, gain.u) annotation (Line(
      points={{-19,-20},{-14,-20}},
      color={0,0,127}));
  connect(volume.port, sensor.port)
    annotation (Line(points={{48,-20},{80,-20}}, color={191,0,0}));
  connect(sensor.T,PID. u_m) annotation (Line(
      points={{91,-10},{94,-10},{94,-44},{-30,-44},{-30,-32}},
      color={0,0,127}));
  connect(Q_flow.port, volume.port)
    annotation (Line(points={{36,-20},{48,-20}}, color={191,0,0}));
  connect(sine.y, boundary.T_ext)
    annotation (Line(points={{-59,20},{6,20}}, color={0,0,127}));
  connect(gain.y, Q_flow.Q_flow_ext)
    annotation (Line(points={{9,-20},{22,-20}}, color={0,0,127}));
 annotation (experiment(Tolerance=1e-6, StopTime=86400),
    Documentation(info="<html>
<p>Example that demonstrates the use of the PID controller with hysteresis. The control objective is to keep the temperature of the energy storage <span style=\"font-family: Courier New;\">cap</span> at <i>40</i>&deg;C. The controller <span style=\"font-family: Courier New;\">con</span> is parameterized to switch on if the control error is bigger than <i>e<sub>on</sub>=1</i>. The output of the controller remains above <i>y<sub>min</sub>=0.3</i> until the control error is smaller than <i>e<sub>off</sub>=-1</i>, at which time the controller outputs <i>y=0</i> until the control error is again bigger than <i>1</i>. The figure below shows the control error <span style=\"font-family: Courier New;\">con.feeBac.y</span> and the control signal <span style=\"font-family: Courier New;\">con.y</span>.  </p>
</html>", revisions="<html>
</html>"));
end LimPID_Hysteresis_Test;
