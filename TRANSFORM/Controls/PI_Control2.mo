within TRANSFORM.Controls;
model PI_Control2 "Proportional controller: y = yb + Kc*e"
  extends Modelica.Blocks.Interfaces.SVcontrol;
  parameter Boolean directActing = true "=false reverse acting" annotation(Evaluate=true);
  parameter Real k(unit="1")=1 "Error gain";
  parameter Real yb = 0 "Output bias";
  parameter Real k_s= 1 "Scaling factor for setpoint: set = k_s*u_s";
  parameter Real k_m= 1 "Scaling factor for measurment: meas = k_m*u_m";
  parameter SI.Time Ti(
    start=1,
    min=Modelica.Constants.small) = 1 "Time Constant (Ti>0 required)";
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
    annotation (Evaluate=true, Dialog(group="Initialization"));
  parameter Real xi_start=0 "Initial or guess value of error integral (state)"
    annotation (Dialog(group="Initialization"));
  parameter Real y_start=0 "Initial value of output" annotation (Dialog(enable=
          initType == Modelica.Blocks.Types.Init.SteadyState or initType == Modelica.Blocks.Types.Init.InitialOutput, group=
         "Initialization"));
  constant SI.Time unitTime=1  annotation(HideResult=true);
  final parameter Real Kc = k*(if directActing then +1 else -1);
  Modelica.Blocks.Math.Gain P(k=Kc) "Proportional part of PID controller"
    annotation (Placement(transformation(extent={{2,30},{22,50}})));
  Modelica.Blocks.Math.Gain gain_u_s(k=k_s)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Math.Gain gain_u_m(k=k_m) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-78})));
  Modelica.Blocks.Math.Add3 add
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant null_bias(k=yb)
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Blocks.Math.Add error(k2=-1)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Continuous.Integrator I(
    k=unitTime/Ti,
    y_start=xi_start,
    initType=initType)
    "Integral part of PID controller"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Math.Gain gain_I(k=Kc)
    annotation (Placement(transformation(extent={{28,-20},{48,0}})));
equation
  connect(u_s, gain_u_s.u)
    annotation (Line(points={{-120,0},{-92,0}}, color={0,0,127}));
  connect(gain_u_m.u, u_m)
    annotation (Line(points={{0,-90},{0,-120}}, color={0,0,127}));
  connect(null_bias.y, add.u1)
    annotation (Line(points={{41,80},{50,80},{50,8},{58,8}}, color={0,0,127}));
  connect(gain_u_m.y, error.u2) annotation (Line(points={{0,-67},{0,-60},{-50,-60},
          {-50,-6},{-42,-6}}, color={0,0,127}));
  connect(gain_u_s.y, error.u1) annotation (Line(points={{-69,0},{-50,0},{-50,6},
          {-42,6}}, color={0,0,127}));
  connect(error.y, P.u)
    annotation (Line(points={{-19,0},{-10,0},{-10,40},{0,40}},
                                              color={0,0,127}));
  connect(add.y, y) annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(I.y, gain_I.u)
    annotation (Line(points={{21,-10},{26,-10}},
                                               color={0,0,127}));
  connect(I.u, error.y) annotation (Line(points={{-2,-10},{-10,-10},{-10,0},{-19,
          0}},
        color={0,0,127}));
  connect(gain_I.y, add.u3) annotation (Line(points={{49,-10},{52,-10},{52,-8},{
          58,-8}}, color={0,0,127}));
  connect(P.y, add.u2)
    annotation (Line(points={{23,40},{48,40},{48,0},{58,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PI_Control2;
