within TRANSFORM.Controls;
model P_Control2 "Proportional controller: y = yb + Kc*e"

  extends Modelica.Blocks.Interfaces.SVcontrol;

  parameter Boolean directActing = true "=false reverse acting" annotation(Evaluate=true);
  parameter Real k(unit="1")=1 "Error gain";
  parameter Real yb = 0 "Output bias";

  parameter Real k_s= 1 "Scaling factor for setpoint: set = k_s*u_s";
  parameter Real k_m= 1 "Scaling factor for measurment: meas = k_m*u_m";

  final parameter Real Kc = k*(if directActing then +1 else -1);

  Modelica.Blocks.Math.Gain P(k=Kc) "Proportional part of PID controller"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Math.Gain gain_u_s(k=k_s)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Math.Gain gain_u_m(k=k_m) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-78})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant null_bias(k=yb)
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Math.Add error(k2=-1)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(u_s, gain_u_s.u)
    annotation (Line(points={{-120,0},{-92,0}}, color={0,0,127}));
  connect(gain_u_m.u, u_m)
    annotation (Line(points={{0,-90},{0,-120}}, color={0,0,127}));
  connect(null_bias.y, add.u1)
    annotation (Line(points={{41,30},{50,30},{50,6},{58,6}}, color={0,0,127}));
  connect(P.y, add.u2)
    annotation (Line(points={{21,0},{50,0},{50,-6},{58,-6}}, color={0,0,127}));
  connect(gain_u_m.y, error.u2) annotation (Line(points={{0,-67},{0,-60},{-50,-60},
          {-50,-6},{-42,-6}}, color={0,0,127}));
  connect(gain_u_s.y, error.u1) annotation (Line(points={{-69,0},{-50,0},{-50,6},
          {-42,6}}, color={0,0,127}));
  connect(error.y, P.u)
    annotation (Line(points={{-19,0},{-2,0}}, color={0,0,127}));
  connect(add.y, y) annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end P_Control2;
