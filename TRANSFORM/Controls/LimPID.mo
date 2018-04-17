within TRANSFORM.Controls;
block LimPID
  "P, PI, PD, and PID controller with limited output, anti-windup compensation, setpoint weighting, feed forward, and reset"
  import Modelica.Blocks.Types.InitPID;
  import Modelica.Blocks.Types.Init;
  import Modelica.Blocks.Types.SimpleController;
  extends Modelica.Blocks.Interfaces.SVcontrol;
  output Real controlError = u_s - u_m
    "Control error (set point - measurement)";

  parameter SimpleController controllerType=
         SimpleController.PID "Type of controller";
  parameter Boolean with_FF=false "enable feed-forward input signal"
    annotation (Evaluate=true);
  parameter Boolean derMeas = true "=true avoid derivative kick" annotation(Evaluate=true,Dialog(enable=controllerType==SimpleController.PD or
                                controllerType==SimpleController.PID));

  parameter Real k = 1 "Controller gain: +/- for direct/reverse acting" annotation(Dialog(group="Parameters: Tuning Controls"));

  parameter SI.Time Ti(min=Modelica.Constants.small)=0.5
    "Time constant of Integrator block" annotation (Dialog(group="Parameters: Tuning Controls",enable=
          controllerType == SimpleController.PI or
          controllerType == SimpleController.PID));
  parameter SI.Time Td(min=0)=0.1 "Time constant of Derivative block"
    annotation (Dialog(group="Parameters: Tuning Controls",enable=controllerType == SimpleController.PD
           or controllerType == SimpleController.PID));

  parameter Real yb = 0 "Output bias. May improve simulation";

  parameter Real k_s= 1 "Setpoint input scaling: k_s*u_s. May improve simulation";
  parameter Real k_m= 1 "Measurement input scaling: k_m*u_m. May improve simulation";
  parameter Real k_ff= 1 "Measurement input scaling: k_ff*u_ff. May improve simulation" annotation(Dialog(enable=with_FF));

  parameter Real yMax(start=1)=Modelica.Constants.inf "Upper limit of output";
  parameter Real yMin=-yMax "Lower limit of output";

  parameter Real wp(min=0) = 1
    "Set-point weight for Proportional block (0..1)" annotation(Dialog(group="Parameters: Tuning Controls"));
  parameter Real wd(min=0) = 0 "Set-point weight for Derivative block (0..1)"
       annotation(Dialog(group="Parameters: Tuning Controls",enable=controllerType==SimpleController.PD or
                                controllerType==SimpleController.PID));
  parameter Real Ni(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
     annotation(Dialog(group="Parameters: Tuning Controls",enable=controllerType==SimpleController.PI or
                              controllerType==SimpleController.PID));
  parameter Real Nd(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
       annotation(Dialog(group="Parameters: Tuning Controls",enable=controllerType==SimpleController.PD or
                                controllerType==SimpleController.PID));
  // Initialization
  parameter .Modelica.Blocks.Types.InitPID initType= .Modelica.Blocks.Types.InitPID.NoInit
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
                                     annotation(Evaluate=true,
      Dialog(tab="Initialization"));
  parameter Real xi_start=0
    "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(tab="Initialization",
                enable=controllerType==SimpleController.PI or
                       controllerType==SimpleController.PID));
  parameter Real xd_start=0
    "Initial or guess value for state of derivative block"
    annotation (Dialog(tab="Initialization",
                         enable=controllerType==SimpleController.PD or
                                controllerType==SimpleController.PID));
  parameter Real y_start=0 "Initial value of output"
    annotation(Dialog(enable=initType == .Modelica.Blocks.Types.InitPID.InitialOutput, tab=
          "Initialization"));
  parameter Boolean strict=false "= true, if strict limits with noEvent(..)"
    annotation (Evaluate=true, choices(checkBox=true), Dialog(tab="Advanced"));
  parameter TRANSFORM.Types.Reset reset = TRANSFORM.Types.Reset.Disabled
    "Type of controller output reset"
    annotation(Evaluate=true, Dialog(group="Integrator reset"));
  parameter Real y_reset=xi_start
    "Value to which the controller output is reset if the boolean trigger has a rising edge, used if reset == TRANSFORM.Types.Reset.Parameter"
    annotation(Dialog(enable=reset == TRANSFORM.Types.Reset.Parameter,
                      group="Integrator reset"));

  Modelica.Blocks.Interfaces.BooleanInput trigger if
       reset <> TRANSFORM.Types.Reset.Disabled
    "Resets the controller output when trigger becomes true"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-80,-120})));

  Modelica.Blocks.Interfaces.RealInput y_reset_in if
       reset == TRANSFORM.Types.Reset.Input
    "Input signal for state to which integrator is reset, enabled if reset = TRANSFORM.Types.Reset.Input"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Blocks.Math.Add addP(k1=wp, k2=-1)
    annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
  Modelica.Blocks.Math.Add addD(k1=wd, k2=-1) if with_D
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Modelica.Blocks.Math.Gain P(k=1)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Blocks.IntegratorWithReset            I(
    k=unitTime/Ti,
    y_start=xi_start,
    initType=if initType == InitPID.SteadyState then Init.SteadyState else if
        initType == InitPID.InitialState or initType == InitPID.DoNotUse_InitialIntegratorState
         then Init.InitialState else Init.NoInit,
    reset=if reset == TRANSFORM.Types.Reset.Disabled then reset else TRANSFORM.Types.Reset.Input,
    y_reset=y_reset) if with_I
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Modelica.Blocks.Continuous.Derivative D(
    k=Td/unitTime,
    T=max([Td/Nd,1.e-14]),
    x_start=xd_start,
    initType=if initType == InitPID.SteadyState or initType == InitPID.InitialOutput
         then Init.SteadyState else if initType == InitPID.InitialState then
        Init.InitialState else Init.NoInit) if with_D
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Math.Gain gainPID(k=k)
    annotation (Placement(transformation(extent={{24,-10},{44,10}})));
  Modelica.Blocks.Math.Add3 addPID
    annotation (Placement(transformation(extent={{-4,-10},{16,10}})));
  Modelica.Blocks.Math.Add3 addI(k2=-1) if with_I
    annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));
  Modelica.Blocks.Math.Add addSat(k1=+1, k2=-1) if with_I annotation (Placement(
        transformation(
        origin={80,-50},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Blocks.Math.Gain gainTrack(k=1/(k*Ni)) if  with_I
    annotation (Placement(transformation(extent={{40,-80},{20,-60}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(
    uMax=yMax,
    uMin=yMin,
    strict=strict,
    u(start=y_start))
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Modelica.Blocks.Interfaces.RealInput u_ff if with_FF
    "Connector of feed-forward signal" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80})));
  Modelica.Blocks.Sources.Constant Fzero(k=0) if not with_FF annotation (
      Placement(transformation(extent={{25,20},{35,30}}, rotation=0)));
  Modelica.Blocks.Sources.Constant Dzero(k=0) if not with_D annotation (
      Placement(transformation(extent={{-30,20},{-20,30}}, rotation=0)));
  Modelica.Blocks.Sources.Constant Izero(k=0) if not with_I annotation (
      Placement(transformation(extent={{-30,-30},{-20,-20}},
                                                          rotation=0)));
  Modelica.Blocks.Math.Add3 addFF
    annotation (Placement(transformation(extent={{50,-5},{60,5}})));

  Modelica.Blocks.Math.Gain gain_u_s(k=k_s)
    annotation (Placement(transformation(extent={{-96,-6},{-84,6}})));
  Modelica.Blocks.Math.Gain gain_u_m(k=k_m) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={0,-90})));
  Modelica.Blocks.Logical.Switch switch_derKick if with_D
    annotation (Placement(transformation(extent={{-66,-30},{-54,-18}})));
  Modelica.Blocks.Sources.BooleanConstant derKick(k=derMeas) if with_D
    annotation (Placement(transformation(extent={{-98,-30},{-86,-18}})));
  Modelica.Blocks.Sources.Constant null_bias(k=yb)
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
protected
  constant SI.Time unitTime=1  annotation(HideResult=true);
  parameter Boolean with_I = controllerType==SimpleController.PI or
                             controllerType==SimpleController.PID annotation(Evaluate=true, HideResult=true);
  parameter Boolean with_D = controllerType==SimpleController.PD or
                             controllerType==SimpleController.PID annotation(Evaluate=true, HideResult=true);
  Modelica.Blocks.Interfaces.RealInput y_reset_internal
   "Internal connector for controller output reset"
   annotation(Evaluate=true);
  Modelica.Blocks.Sources.RealExpression intRes(final y=y_reset_internal/k -
        addPID.u1 - addPID.u2) if
       reset <> TRANSFORM.Types.Reset.Disabled
    "Signal source for integrator reset"
    annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));

public
  Modelica.Blocks.Math.Gain gain_u_ff(k=k_ff)
    annotation (Placement(transformation(extent={{-96,74},{-84,86}})));
initial equation
  if initType==InitPID.InitialOutput then
     y = y_start;
  end if;

equation
  assert(yMax >= yMin, "LimPID: Limits must be consistent. However, yMax (=" +
    String(yMax) + ") < yMin (=" + String(yMin) + ")");
  if initType == InitPID.InitialOutput and (y_start < yMin or y_start > yMax) then
    Modelica.Utilities.Streams.error("LimPID: Start value y_start (=" + String(
      y_start) + ") is outside of the limits of yMin (=" + String(yMin) +
      ") and yMax (=" + String(yMax) + ")");
  end if;

  // Equations for conditional connectors
  connect(y_reset_in, y_reset_internal);

  if reset <> TRANSFORM.Types.Reset.Input then
    y_reset_internal = y_reset;
  end if;


  connect(addP.y, P.u) annotation (Line(points={{-49,50},{-42,50}}, color={0,
          0,127}));
  connect(addI.y, I.u) annotation (Line(points={{-49,-50},{-42,-50}}, color={
          0,0,127}));
  connect(P.y, addPID.u1) annotation (Line(points={{-19,50},{-10,50},{-10,8},{-6,
          8}},     color={0,0,127}));
  connect(D.y, addPID.u2)
    annotation (Line(points={{-19,0},{-6,0}}, color={0,0,127}));
  connect(I.y, addPID.u3) annotation (Line(points={{-19,-50},{-10,-50},{-10,-8},
          {-6,-8}},     color={0,0,127}));
  connect(addPID.y, gainPID.u)
    annotation (Line(points={{17,0},{22,0}}, color={0,0,127}));
  connect(limiter.y, addSat.u1) annotation (Line(points={{93,0},{96,0},{96,-20},
          {86,-20},{86,-38}},      color={0,0,127}));
  connect(limiter.y, y)
    annotation (Line(points={{93,0},{110,0}}, color={0,0,127}));
  connect(addSat.y, gainTrack.u) annotation (Line(points={{80,-61},{80,-70},{
          42,-70}}, color={0,0,127}));
  connect(gainTrack.y, addI.u3) annotation (Line(points={{19,-70},{-76,-70},{-76,
          -58},{-72,-58}},     color={0,0,127}));
  connect(Dzero.y, addPID.u2) annotation (Line(points={{-19.5,25},{-14,25},{-14,
          0},{-6,0}},     color={0,0,127}));
  connect(gainPID.y, addFF.u2)
    annotation (Line(points={{45,0},{47,0},{47,0},{49,0}},
                                                    color={0,0,127}));
  connect(Fzero.y, addFF.u1) annotation (Line(points={{35.5,25},{44,25},{44,4},{
          49,4}}, color={0,0,127}));
  connect(addFF.y, limiter.u)
    annotation (Line(points={{60.5,0},{64,0},{70,0}}, color={0,0,127}));
  connect(addSat.u2, limiter.u) annotation (Line(points={{74,-38},{74,-20},{64,-20},
          {64,0},{70,0}}, color={0,0,127}));
  connect(Izero.y, addPID.u3) annotation (Line(points={{-19.5,-25},{-14,-25},{
          -14,-50},{-10,-50},{-10,-8},{-6,-8}}, color={0,0,127}));
  connect(u_s, gain_u_s.u)
    annotation (Line(points={{-120,0},{-97.2,0}}, color={0,0,127}));
  connect(gain_u_s.y, addP.u1) annotation (Line(points={{-83.4,0},{-80,0},{-80,56},
          {-72,56}}, color={0,0,127}));
  connect(addD.u1, addP.u1) annotation (Line(points={{-72,6},{-80,6},{-80,56},{-72,
          56}}, color={0,0,127}));
  connect(gain_u_s.y, addI.u1) annotation (Line(points={{-83.4,0},{-80,0},{-80,-42},
          {-72,-42}}, color={0,0,127}));
  connect(gain_u_m.u, u_m)
    annotation (Line(points={{0,-97.2},{0,-120}}, color={0,0,127}));
  connect(gain_u_m.y, addP.u2) annotation (Line(points={{0,-83.4},{0,-80},{-78,-80},
          {-78,44},{-72,44}}, color={0,0,127}));
  connect(addD.u2, addP.u2) annotation (Line(points={{-72,-6},{-78,-6},{-78,44},
          {-72,44}}, color={0,0,127}));
  connect(addI.u2, addP.u2) annotation (Line(points={{-72,-50},{-78,-50},{-78,44},
          {-72,44}}, color={0,0,127}));
  connect(switch_derKick.u1, addP.u2) annotation (Line(points={{-67.2,-19.2},{-78,
          -19.2},{-78,44},{-72,44}}, color={0,0,127}));
  connect(switch_derKick.u3, addD.y) annotation (Line(points={{-67.2,-28.8},{-74,
          -28.8},{-74,-14},{-49,-14},{-49,0}}, color={0,0,127}));
  connect(switch_derKick.y, D.u) annotation (Line(points={{-53.4,-24},{-46,-24},
          {-46,0},{-42,0}}, color={0,0,127}));
  connect(derKick.y, switch_derKick.u2)
    annotation (Line(points={{-85.4,-24},{-67.2,-24}}, color={255,0,255}));
  connect(null_bias.y, addFF.u3) annotation (Line(points={{41,-30},{44,-30},{44,
          -4},{49,-4}}, color={0,0,127}));
  connect(intRes.y, I.y_reset_in) annotation (Line(points={{-69,-90},{-46,-90},{
          -46,-58},{-42,-58}}, color={0,0,127}));
  connect(trigger, I.trigger) annotation (Line(points={{-80,-120},{-80,-96},{-30,
          -96},{-30,-62}}, color={255,0,255}));
  connect(u_ff, gain_u_ff.u)
    annotation (Line(points={{-120,80},{-97.2,80}}, color={0,0,127}));
  connect(gain_u_ff.y, addFF.u1) annotation (Line(points={{-83.4,80},{44,80},{
          44,4},{49,4}},
                      color={0,0,127}));
  annotation (defaultComponentName="PID",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{-80,-20},{30,60},{80,60}}, color={0,0,127}),
        Text(
          extent={{-20,-20},{80,-60}},
          lineColor={192,192,192},
          textString="%controllerType"),
        Line(
          visible=strict,
          points={{30,60},{81,60}},
          color={255,0,0})}),
    Documentation(info="<html>
<p>This model duplicates the LimPID in the Modelica Standard Library but modifies it to enable a feed forward control option.</p>
<p>Via parameter <b>controllerType</b> either <b>P</b>, <b>PI</b>, <b>PD</b>, or <b>PID</b> can be selected. If, e.g., PI is selected, all components belonging to the D-part are removed from the block (via conditional declarations). The example model <a href=\"modelica://Modelica.Blocks.Examples.PID_Controller\">Modelica.Blocks.Examples.PID_Controller</a> demonstrates the usage of this controller. Several practical aspects of PID controller design are incorporated according to chapter 3 of the book: </p>
<dl><dt>&Aring;str&ouml;m K.J., and H&auml;gglund T.:</dt>
<dd><b>PID Controllers: Theory, Design, and Tuning</b>. Instrument Society of America, 2nd edition, 1995. </dd>
</dl><p>Besides the additive <b>proportional, integral</b> and <b>derivative</b> part of this controller, the following features are present: </p>
<ol>
<li>The output of this controller is limited. If the controller is in its limits, anti-windup compensation is activated to drive the integrator state to zero. </li>
<li>The high-frequency gain of the derivative part is limited to avoid excessive amplification of measurement noise.</li>
<li>Setpoint weighting is present, which allows to weight the setpoint in the proportional and the derivative part independently from the measurement. The controller will respond to load disturbances and measurement noise independently of this setting (parameters wp, wd). However, setpoint changes will depend on this setting. For example, it is useful to set the setpoint weight wd for the derivative part to zero, if steps may occur in the setpoint signal. </li>
<li>Feed forward option is available on any controllerType</li>
<li>derMeas = true uses the derivative on measurement value only to avoid the derivative kick of setpoint changes. = false will take the derivative w.r.t. error</li>
<li>It can be configured to enable an input port that allows resetting the controller output. The controller output can be reset as follows: </li>
<ul>
<li>If reset = TRANSFORM.Types.Reset.Disabled, which is the default, then the controller output is never reset. </li>
<li>If reset = TRANSFORM.Types.Reset.Parameter, then a boolean input signal trigger is enabled. Whenever the value of this input changes from false to true, the controller output is reset by setting y to the value of the parameter y_reset. </li>
<li>If reset = TRANSFORM.Types.Reset.Input, then a boolean input signal trigger is enabled. Whenever the value of this input changes from false to true, the controller output is reset by setting y to the value of the input signal y_reset_in. </li>
</ul>
</ol>
<p>Note that this controller implements an integrator anti-windup. Therefore, for most applications, keeping the default setting of reset = TRANSFORM.Types.Reset.Disabled is sufficient. Examples where it may be beneficial to reset the controller output are situations where the equipment control input should continuously increase as the equipment is switched on, such as as a light dimmer that may slowly increase the luminance, or a variable speed drive of a motor that should continuously increase the speed. </p>
<p>The parameters of the controller can be manually adjusted by performing simulations of the closed loop system (= controller + plant connected together) and using the following strategy: </p>
<ol>
<li>Set very large limits, e.g., yMax = Modelica.Constants.inf</li>
<li>Select a <b>P</b>-controller and manually enlarge parameter <b>k</b> (the total gain of the controller) until the closed-loop response cannot be improved any more.</li>
<li>Select a <b>PI</b>-controller and manually adjust parameters <b>k</b> and <b>Ti</b> (the time constant of the integrator). The first value of Ti can be selected, such that it is in the order of the time constant of the oscillations occurring with the P-controller. If, e.g., vibrations in the order of T=10 ms occur in the previous step, start with Ti=0.01 s.</li>
<li>If you want to make the reaction of the control loop faster (but probably less robust against disturbances and measurement noise) select a <b>PID</b>-Controller and manually adjust parameters <b>k</b>, <b>Ti</b>, <b>Td</b> (time constant of derivative block).</li>
<li>Set the limits yMax and yMin according to your specification.</li>
<li>Perform simulations such that the output of the PID controller goes in its limits. Tune <b>Ni</b> (Ni*Ti is the time constant of the anti-windup compensation) such that the input to the limiter block (= limiter.u) goes quickly enough back to its limits. If Ni is decreased, this happens faster. If Ni=infinity, the anti-windup compensation is switched off and the controller works bad. </li>
</ol>
<p><b>Initialization</b> </p>
<p>This block can be initialized in different ways controlled by parameter <b>initType</b>. The possible values of initType are defined in <a href=\"modelica://Modelica.Blocks.Types.InitPID\">Modelica.Blocks.Types.InitPID</a>. This type is identical to <a href=\"modelica://Modelica.Blocks.Types.Init\">Types.Init</a>, with the only exception that the additional option <b>DoNotUse_InitialIntegratorState</b> is added for backward compatibility reasons (= integrator is initialized with InitialState whereas differential part is initialized with NoInit which was the initialization in version 2.2 of the Modelica standard library). </p>
<p>Based on the setting of initType, the integrator (I) and derivative (D) blocks inside the PID controller are initialized according to the following table: </p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\"><tr>
<td valign=\"top\"><h4>initType</h4></td>
<td valign=\"top\"><h4>I.initType</h4></td>
<td valign=\"top\"><h4>D.initType</h4></td>
</tr>
<tr>
<td valign=\"top\"><h4>NoInit</h4></td>
<td valign=\"top\"><p>NoInit</p></td>
<td valign=\"top\"><p>NoInit</p></td>
</tr>
<tr>
<td valign=\"top\"><h4>SteadyState</h4></td>
<td valign=\"top\"><p>SteadyState</p></td>
<td valign=\"top\"><p>SteadyState</p></td>
</tr>
<tr>
<td valign=\"top\"><h4>InitialState</h4></td>
<td valign=\"top\"><p>InitialState</p></td>
<td valign=\"top\"><p>InitialState</p></td>
</tr>
<tr>
<td valign=\"top\"><h4>InitialOutput</h4><p>and initial equation: y = y_start</p></td>
<td valign=\"top\"><p>NoInit</p></td>
<td valign=\"top\"><p>SteadyState</p></td>
</tr>
<tr>
<td valign=\"top\"><h4>DoNotUse_InitialIntegratorState</h4></td>
<td valign=\"top\"><p>InitialState</p></td>
<td valign=\"top\"><p>NoInit</p></td>
</tr>
</table>
<p><br><br><br><br><br><br>In many cases, the most useful initial condition is <b>SteadyState</b> because initial transients are then no longer present. If initType = InitPID.SteadyState, then in some cases difficulties might occur. The reason is the equation of the integrator: </p>
<p><b><span style=\"font-family: Courier New;\">der</span></b>(y) = k*u; </p>
<p>The steady state equation &quot;der(x)=0&quot; leads to the condition that the input u to the integrator is zero. If the input u is already (directly or indirectly) defined by another initial condition, then the initialization problem is <b>singular</b> (has none or infinitely many solutions). This situation occurs often for mechanical systems, where, e.g., u = desiredSpeed - measuredSpeed and since speed is both a state and a derivative, it is natural to initialize it with zero. As sketched this is, however, not possible. The solution is to not initialize u_m or the variable that is used to compute u_m by an algebraic equation. </p>
<p>If parameter <b>limitAtInit</b> = <b>false</b>, the limits at the output of this controller block are removed from the initialization problem which leads to a much simpler equation system. After initialization has been performed, it is checked via an assert whether the output is in the defined limits. For backward compatibility reasons <b>limitAtInit</b> = <b>true</b>. In most cases it is best to use <b>limitAtInit</b> = <b>false</b>. </p>
</html>"),
    Diagram(graphics={         Text(
          extent={{-98,106},{-158,96}},
          lineColor={0,0,255},
          textString="(feed-forward)")}));
end LimPID;
