within TRANSFORM.Examples.LightWaterReactor_PWR_Westinghouse;
model CS_Tavg_CR_P_withLag

  extends BaseClasses.Partial_ControlSystem;

  parameter SI.Time delayStart_N=50 "Delay pump speed control";
  parameter SI.Time delayStart_CR=25 "Delay control rod reactivity control";

  Modelica.Blocks.Sources.Constant Other_Reactivity(k=0)
    annotation (Placement(transformation(extent={{220,10},{240,30}})));
  Modelica.Blocks.Sources.Constant S_external(k=0)
    annotation (Placement(transformation(extent={{220,-20},{240,0}})));
  Modelica.Blocks.Sources.Constant speedPump_nominal(k=1550) "1500"
    annotation (Placement(transformation(extent={{110,160},{130,180}})));
  Modelica.Blocks.Math.Add speedPump
    annotation (Placement(transformation(extent={{150,180},{170,200}})));
  Modelica.Blocks.Sources.Constant CR_nominal(k=0)
    annotation (Placement(transformation(extent={{110,30},{130,50}})));
  Modelica.Blocks.Sources.Clock clock(offset=0, startTime=0)
    annotation (Placement(transformation(extent={{-260,140},{-240,160}})));
  Modelica.Blocks.Logical.Greater greater5
    annotation (Placement(transformation(extent={{-220,180},{-200,160}})));
  Modelica.Blocks.Sources.Constant pumpDelay(k=delayStart_N)
    annotation (Placement(transformation(extent={{-260,180},{-240,200}})));
  Modelica.Blocks.Logical.Switch switch_speedOffset
    annotation (Placement(transformation(extent={{110,200},{130,220}})));
  Modelica.Blocks.Sources.Constant speedOffset_nominal(k=0)
    annotation (Placement(transformation(extent={{70,180},{90,200}})));
  Modelica.Blocks.Sources.Constant Q_total_nominal(k=data.Q_totalTh) "1.00e9"
    annotation (Placement(transformation(extent={{-150,90},{-130,110}})));
  Modelica.Blocks.Math.Add CRReactivity
    annotation (Placement(transformation(extent={{150,50},{170,70}})));
  Modelica.Blocks.Sources.Constant CROffset_nominal(k=0)
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Modelica.Blocks.Logical.Switch switch_CR
    annotation (Placement(transformation(extent={{110,70},{130,90}})));
  Modelica.Blocks.Logical.Greater greater
    annotation (Placement(transformation(extent={{-220,120},{-200,140}})));
  Modelica.Blocks.Sources.Constant CRDelay(k=delayStart_CR)
    annotation (Placement(transformation(extent={{-260,100},{-240,120}})));
  Modelica.Blocks.Logical.Switch switch_Q_total
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Modelica.Blocks.Math.Add Q_total_setpoint
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Modelica.Blocks.Sources.Step DeltaT_Stpt_Addr1(                height=20e6,
      startTime=1500e10)
    annotation (Placement(transformation(extent={{-190,70},{-170,90}})));
  Modelica.Blocks.Math.Add Control_Add3
    annotation (Placement(transformation(extent={{-150,50},{-130,70}})));
  Modelica.Blocks.Sources.Step DeltaT_Stpt_Addr2(height=-3*10e6, startTime=
        1000e10)
    annotation (Placement(transformation(extent={{-190,30},{-170,50}})));
  Modelica.Blocks.Math.Gain gain(k=1e-9) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={40,80})));
  Modelica.Blocks.Math.Gain gain1(
                                 k=1e-9) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={40,110})));
  Modelica.Blocks.Continuous.LimPID PID_CR(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    initType=Modelica.Blocks.Types.InitPID.SteadyState,
    yMax=1e-2,
    Ti=0.25,
    k=1e-3) annotation (Placement(transformation(extent={{70,90},{90,110}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-90,260},{-70,280}})));
  Modelica.Blocks.Math.Division T_avg_meas
    annotation (Placement(transformation(extent={{-50,240},{-30,260}})));
  Modelica.Blocks.Sources.Constant Divisor(k=2)
    annotation (Placement(transformation(extent={{-90,220},{-70,240}})));
  Modelica.Blocks.Sources.Constant T_avg_nominal(k=576) "576"
    annotation (Placement(transformation(extent={{-50,200},{-30,220}})));
  Modelica.Blocks.Continuous.LimPID PID_pump(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    initType=Modelica.Blocks.Types.InitPID.SteadyState,
    Ti=500,
    k=30,
    yMax=400) annotation (Placement(transformation(extent={{30,220},{50,240}})));
  Modelica.Blocks.Logical.Switch switch_T_avg
    annotation (Placement(transformation(extent={{-10,220},{10,240}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(k=1, T=25)
    annotation (Placement(transformation(extent={{70,220},{90,240}})));
  Modelica.Blocks.Nonlinear.Limiter Q_total_setpoint_limit(uMax=1.1e9, uMin=
        0.2e9)
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=15.0e6, uHigh=15.5e6)
    annotation (Placement(transformation(extent={{48,-60},{68,-40}})));
  Modelica.Blocks.Logical.Switch switch_liquidHeater
    annotation (Placement(transformation(extent={{160,-60},{180,-40}})));
  Modelica.Blocks.Sources.Constant Q_liquidHeater(k=150e4)
    "heat to liquid heater"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Modelica.Blocks.Sources.Constant zeroheat(k=0)
    annotation (Placement(transformation(extent={{80,-91},{100,-71}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Modelica.Blocks.Logical.Switch switch_Q_total1
    annotation (Placement(transformation(extent={{120,-40},{140,-20}})));
  Data.Data_Basic data
    annotation (Placement(transformation(extent={{-10,-88},{10,-68}})));
equation

  connect(gain.y, PID_CR.u_m)
    annotation (Line(points={{51,80},{80,80},{80,88}}, color={0,0,127}));
  connect(pumpDelay.y, greater5.u2) annotation (Line(points={{-239,190},{-234,
          190},{-234,178},{-222,178}}, color={0,0,127}));
  connect(clock.y, greater5.u1) annotation (Line(points={{-239,150},{-234,150},
          {-234,170},{-222,170}}, color={0,0,127}));
  connect(PID_pump.y, firstOrder.u)
    annotation (Line(points={{51,230},{68,230}}, color={0,0,127}));
  connect(switch_CR.y, CRReactivity.u1) annotation (Line(points={{131,80},{138,
          80},{138,66},{148,66}}, color={0,0,127}));
  connect(CR_nominal.y, CRReactivity.u2) annotation (Line(points={{131,40},{
          139.5,40},{139.5,54},{148,54}}, color={0,0,127}));
  connect(CROffset_nominal.y, switch_CR.u3) annotation (Line(points={{91,60},{
          98,60},{98,72},{108,72}}, color={0,0,127}));
  connect(PID_CR.y, switch_CR.u1) annotation (Line(points={{91,100},{98.5,100},
          {98.5,88},{108,88}},color={0,0,127}));
  connect(gain1.y, PID_CR.u_s) annotation (Line(points={{51,110},{56,110},{56,
          100},{68,100}},
                    color={0,0,127}));
  connect(switch_Q_total.y, gain.u)
    annotation (Line(points={{11,80},{20,80},{28,80}}, color={0,0,127}));
  connect(Q_total_setpoint_limit.y, switch_Q_total.u3) annotation (Line(points={{-49,80},
          {-38,80},{-38,72},{-12,72}},           color={0,0,127}));
  connect(gain1.u, switch_Q_total.u3) annotation (Line(points={{28,110},{-38,
          110},{-38,72},{-12,72}},
                              color={0,0,127}));
  connect(Q_total_setpoint.y, Q_total_setpoint_limit.u)
    annotation (Line(points={{-89,80},{-89,80},{-72,80}}, color={0,0,127}));
  connect(Q_total_nominal.y, Q_total_setpoint.u1) annotation (Line(points={{-129,
          100},{-122,100},{-122,86},{-112,86}},
                                              color={0,0,127}));
  connect(Control_Add3.y, Q_total_setpoint.u2) annotation (Line(points={{-129,60},
          {-120,60},{-120,74},{-112,74}},     color={0,0,127}));
  connect(DeltaT_Stpt_Addr1.y, Control_Add3.u1) annotation (Line(points={{-169,80},
          {-162,80},{-162,66},{-152,66}}, color={0,0,127}));
  connect(DeltaT_Stpt_Addr2.y, Control_Add3.u2) annotation (Line(points={{-169,40},
          {-160,40},{-160,54},{-152,54}}, color={0,0,127}));
  connect(greater.y, switch_CR.u2) annotation (Line(points={{-199,130},{-200,
          130},{102,130},{102,80},{108,80}}, color={255,0,255}));
  connect(switch_Q_total.u2, switch_CR.u2) annotation (Line(points={{-12,80},{
          -20,80},{-20,130},{102,130},{102,80},{108,80}}, color={255,0,255}));

  connect(CRDelay.y, greater.u2) annotation (Line(points={{-239,110},{-232,110},
          {-232,122},{-222,122}},color={0,0,127}));
  connect(greater.u1, greater5.u1) annotation (Line(points={{-222,130},{-234,
          130},{-234,170},{-222,170}}, color={0,0,127}));
  connect(speedPump_nominal.y, speedPump.u2) annotation (Line(points={{131,170},
          {138,170},{138,184},{148,184}}, color={0,0,127}));
  connect(switch_speedOffset.y, speedPump.u1) annotation (Line(points={{131,210},
          {138,210},{138,196},{148,196}}, color={0,0,127}));
  connect(speedOffset_nominal.y, switch_speedOffset.u3) annotation (Line(points=
         {{91,190},{98,190},{98,202},{108,202}}, color={0,0,127}));
  connect(firstOrder.y, switch_speedOffset.u1) annotation (Line(points={{91,230},
          {98,230},{98,218},{108,218}}, color={0,0,127}));
  connect(T_avg_nominal.y, switch_T_avg.u3) annotation (Line(points={{-29,210},
          {-20,210},{-20,222},{-12,222}}, color={0,0,127}));
  connect(T_avg_meas.y, switch_T_avg.u1) annotation (Line(points={{-29,250},{-22,
          250},{-22,238},{-12,238}}, color={0,0,127}));
  connect(Divisor.y, T_avg_meas.u2) annotation (Line(points={{-69,230},{-62,230},
          {-62,244},{-52,244}}, color={0,0,127}));
  connect(add.y, T_avg_meas.u1) annotation (Line(points={{-69,270},{-62,270},{-62,
          256},{-52,256}}, color={0,0,127}));
  connect(switch_T_avg.u2, switch_speedOffset.u2) annotation (Line(points={{-12,
          230},{-18,230},{-18,170},{50,170},{50,210},{108,210}}, color={255,0,
          255}));
  connect(greater5.y, switch_speedOffset.u2) annotation (Line(points={{-199,170},
          {50,170},{50,210},{108,210}}, color={255,0,255}));
  connect(PID_pump.u_m, T_avg_nominal.y)
    annotation (Line(points={{40,218},{40,210},{-29,210}}, color={0,0,127}));
  connect(PID_pump.u_s, switch_T_avg.y)
    annotation (Line(points={{28,230},{11,230}}, color={0,0,127}));
  connect(hysteresis.y, not1.u)
    annotation (Line(points={{69,-50},{78,-50}}, color={255,0,255}));
  connect(not1.y, switch_liquidHeater.u2) annotation (Line(points={{101,-50},{
          130,-50},{158,-50}}, color={255,0,255}));
  connect(Q_liquidHeater.y, switch_Q_total1.u1) annotation (Line(points={{101,
          -10},{108,-10},{108,-22},{118,-22}}, color={0,0,127}));
  connect(zeroheat.y, switch_liquidHeater.u3) annotation (Line(points={{101,-81},
          {141,-81},{141,-58},{158,-58}}, color={0,0,127}));
  connect(zeroheat.y, switch_Q_total1.u3) annotation (Line(points={{101,-81},{
          110,-81},{110,-38},{118,-38}}, color={0,0,127}));
  connect(switch_Q_total.u2, switch_Q_total1.u2) annotation (Line(points={{-12,
          80},{-12,80},{-20,80},{-20,80},{-20,80},{-20,-30},{118,-30}}, color={
          255,0,255}));
  connect(switch_Q_total1.y, switch_liquidHeater.u1) annotation (Line(points={{
          141,-30},{150,-30},{150,-42},{158,-42}}, color={0,0,127}));
  connect(sensorBus.T_Core_Inlet, add.u1) annotation (Line(
      points={{-29.9,-99.9},{-114,-99.9},{-300,-99.9},{-300,276},{-92,276}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(sensorBus.T_Core_Outlet, add.u2) annotation (Line(
      points={{-29.9,-99.9},{-140,-99.9},{-300,-99.9},{-300,264},{-92,264}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(sensorBus.Q_total, switch_Q_total.u1) annotation (Line(
      points={{-29.9,-99.9},{-29.9,-99.9},{-29.9,80},{-29.9,88},{-12,88}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(sensorBus.p_pressurizer, hysteresis.u) annotation (Line(
      points={{-29.9,-99.9},{-29.9,-99.9},{-29.9,-50},{46,-50}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(actuatorBus.speedPump, speedPump.y) annotation (Line(
      points={{30.1,-99.9},{280,-99.9},{280,190},{171,190}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(actuatorBus.reactivity_ControlRod, CRReactivity.y)
    annotation (Line(
      points={{30.1,-99.9},{30.1,-99.9},{280,-99.9},{280,60},{171,60}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(actuatorBus.reactivity_Other, Other_Reactivity.y)
    annotation (Line(
      points={{30.1,-99.9},{30.1,-99.9},{280,-99.9},{280,20},{241,20}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(actuatorBus.Q_S_External, S_external.y) annotation (Line(
      points={{30.1,-99.9},{30.1,-99.9},{280,-99.9},{280,-10},{241,-10}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(actuatorBus.Q_flow_liquidHeater, switch_liquidHeater.y)
    annotation (Line(
      points={{30.1,-99.9},{30.1,-99.9},{280,-99.9},{280,-50},{181,-50}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));

annotation(defaultComponentName="PHS_CS", Icon(coordinateSystem(extent={{-100,-100},
            {100,100}}),                       graphics={
        Text(
          extent={{-94,82},{94,74}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,237},
          fillPattern=FillPattern.Solid,
          textString="CS: Tavg/CR/Pressure with start lag")}),
    Diagram(coordinateSystem(extent={{-300,-100},{280,280}})));
end CS_Tavg_CR_P_withLag;
