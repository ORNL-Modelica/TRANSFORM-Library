within TRANSFORM.Examples.LightWaterReactor_PWR_Westinghouse;
model CS_v2 "Core: Tavg | Boiler Level: dT_avg"

  extends BaseClasses.Partial_ControlSystem;

  parameter SI.Time delayStart_SGpump=0 "Delay SG recirc pump control";
  parameter SI.Time delayStart_CR=0 "Delay control rod reactivity control";
  parameter SI.Time delayStart_PZRheater=0 "Delay pressurizer heater control";

  Modelica.Blocks.Sources.Clock clock(offset=0, startTime=0)
    annotation (Placement(transformation(extent={{-170,60},{-150,80}})));
  Modelica.Blocks.Logical.Greater greater5
    annotation (Placement(transformation(extent={{-130,100},{-110,80}})));
  Modelica.Blocks.Sources.Constant delay_CR(k=delayStart_CR)
    annotation (Placement(transformation(extent={{-170,100},{-150,120}})));
  Modelica.Blocks.Logical.Greater greater
    annotation (Placement(transformation(extent={{-130,40},{-110,60}})));
  Modelica.Blocks.Sources.Constant delay_SGpump(k=delayStart_SGpump)
    annotation (Placement(transformation(extent={{-170,20},{-150,40}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-90,170},{-70,190}})));
  Modelica.Blocks.Math.Division T_avg_meas
    annotation (Placement(transformation(extent={{-50,150},{-30,170}})));
  Modelica.Blocks.Sources.Constant Divisor(k=2)
    annotation (Placement(transformation(extent={{-90,130},{-70,150}})));
  Modelica.Blocks.Sources.Constant T_avg_nominal(k=data.T_core_avg)
                                                        "576"
    annotation (Placement(transformation(extent={{-50,110},{-30,130}})));
  Controls.LimPID PID_CR(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    initType=Modelica.Blocks.Types.InitPID.SteadyState,
    k_s=1/data.T_core_avg,
    k_m=1/data.T_core_avg)
    annotation (Placement(transformation(extent={{30,130},{50,110}})));
  Modelica.Blocks.Logical.Switch switch_CR
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=15.0e6, uHigh=15.5e6)
    annotation (Placement(transformation(extent={{48,-40},{68,-20}})));
  Modelica.Blocks.Logical.Switch switch_liquidHeater
    annotation (Placement(transformation(extent={{160,-40},{180,-20}})));
  Modelica.Blocks.Sources.Constant Q_liquidHeater(k=150e4)
    "heat to liquid heater"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Modelica.Blocks.Sources.Constant zeroheat(k=0)
    annotation (Placement(transformation(extent={{80,-71},{100,-51}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  Modelica.Blocks.Logical.Switch switch_Q_total1
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  Data.Data_Basic data
    annotation (Placement(transformation(extent={{-10,-88},{10,-68}})));
  Controls.LimPID PID_SGpump(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yb=data.m_flow_shellSide_total,
    k_s=1/data.T_core_avgRise_nominal,
    k_m=1/data.T_core_avgRise_nominal)
    annotation (Placement(transformation(extent={{30,40},{50,20}})));
  Modelica.Blocks.Logical.Switch switch_SGpump
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Modelica.Blocks.Sources.Constant dT_core_nominal(k=data.T_core_avgRise_nominal)
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Modelica.Blocks.Math.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  Modelica.Blocks.Logical.Greater greater1
    annotation (Placement(transformation(extent={{-130,-20},{-110,0}})));
  Modelica.Blocks.Sources.Constant delay_PZRheater(k=delayStart_PZRheater)
    annotation (Placement(transformation(extent={{-170,-40},{-150,-20}})));
  Modelica.Blocks.Math.Gain FWpump(k=1)
    annotation (Placement(transformation(extent={{180,-90},{200,-70}})));
equation

  connect(delay_CR.y, greater5.u2) annotation (Line(points={{-149,110},{-144,110},
          {-144,98},{-132,98}}, color={0,0,127}));
  connect(clock.y, greater5.u1) annotation (Line(points={{-149,70},{-144,70},{-144,
          90},{-132,90}},         color={0,0,127}));

  connect(delay_SGpump.y, greater.u2) annotation (Line(points={{-149,30},{-142,30},
          {-142,42},{-132,42}}, color={0,0,127}));
  connect(greater.u1, greater5.u1) annotation (Line(points={{-132,50},{-144,50},
          {-144,90},{-132,90}},        color={0,0,127}));
  connect(T_avg_nominal.y, switch_CR.u3) annotation (Line(points={{-29,120},{-20,
          120},{-20,132},{-12,132}}, color={0,0,127}));
  connect(T_avg_meas.y, switch_CR.u1) annotation (Line(points={{-29,160},{-22,160},
          {-22,148},{-12,148}}, color={0,0,127}));
  connect(Divisor.y, T_avg_meas.u2) annotation (Line(points={{-69,140},{-62,140},
          {-62,154},{-52,154}}, color={0,0,127}));
  connect(add.y, T_avg_meas.u1) annotation (Line(points={{-69,180},{-62,180},{-62,
          166},{-52,166}}, color={0,0,127}));
  connect(hysteresis.y, not1.u)
    annotation (Line(points={{69,-30},{78,-30}}, color={255,0,255}));
  connect(not1.y, switch_liquidHeater.u2) annotation (Line(points={{101,-30},{158,
          -30}},               color={255,0,255}));
  connect(Q_liquidHeater.y, switch_Q_total1.u1) annotation (Line(points={{101,10},
          {108,10},{108,-2},{118,-2}},         color={0,0,127}));
  connect(zeroheat.y, switch_liquidHeater.u3) annotation (Line(points={{101,-61},
          {141,-61},{141,-38},{158,-38}}, color={0,0,127}));
  connect(zeroheat.y, switch_Q_total1.u3) annotation (Line(points={{101,-61},{110,
          -61},{110,-18},{118,-18}},     color={0,0,127}));
  connect(switch_Q_total1.y, switch_liquidHeater.u1) annotation (Line(points={{141,-10},
          {150,-10},{150,-22},{158,-22}},          color={0,0,127}));
  connect(sensorBus.T_Core_Inlet, add.u1) annotation (Line(
      points={{-29.9,-99.9},{-29.9,-100},{-180,-100},{-180,186},{-92,186}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(sensorBus.T_Core_Outlet, add.u2) annotation (Line(
      points={{-29.9,-99.9},{-29.9,-100},{-180,-100},{-180,174},{-92,174}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(sensorBus.p_pressurizer, hysteresis.u) annotation (Line(
      points={{-29.9,-99.9},{-29.9,-30},{46,-30}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(actuatorBus.Q_flow_liquidHeater, switch_liquidHeater.y)
    annotation (Line(
      points={{30.1,-99.9},{280,-99.9},{280,-30},{181,-30}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));

  connect(greater5.y, switch_CR.u2) annotation (Line(points={{-109,90},{-58,90},
          {-58,140},{-12,140}},color={255,0,255}));
  connect(dT_core_nominal.y, switch_SGpump.u3) annotation (Line(points={{-29,30},
          {-20,30},{-20,42},{-12,42}}, color={0,0,127}));
  connect(sensorBus.T_Core_Outlet, add1.u1) annotation (Line(
      points={{-29.9,-99.9},{-80,-99.9},{-80,76},{-52,76}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(sensorBus.T_Core_Inlet, add1.u2) annotation (Line(
      points={{-29.9,-99.9},{-80,-99.9},{-80,64},{-52,64}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(greater.y, switch_SGpump.u2)
    annotation (Line(points={{-109,50},{-12,50}}, color={255,0,255}));
  connect(T_avg_nominal.y, PID_CR.u_s)
    annotation (Line(points={{-29,120},{28,120}}, color={0,0,127}));
  connect(switch_CR.y, PID_CR.u_m)
    annotation (Line(points={{11,140},{40,140},{40,132}}, color={0,0,127}));
  connect(dT_core_nominal.y, PID_SGpump.u_s)
    annotation (Line(points={{-29,30},{28,30}}, color={0,0,127}));
  connect(switch_SGpump.y, PID_SGpump.u_m)
    annotation (Line(points={{11,50},{40,50},{40,42}}, color={0,0,127}));
  connect(actuatorBus.reactivity_ControlRod, PID_CR.y) annotation (Line(
      points={{30.1,-99.9},{280,-99.9},{280,120},{51,120}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(actuatorBus.SGpump_m_flow, PID_SGpump.y) annotation (Line(
      points={{30.1,-99.9},{280,-99.9},{280,30},{51,30}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(switch_SGpump.u1, add1.y) annotation (Line(points={{-12,58},{-20,58},{
          -20,70},{-29,70}}, color={0,0,127}));
  connect(delay_PZRheater.y, greater1.u2) annotation (Line(points={{-149,-30},{-140,
          -30},{-140,-18},{-132,-18}}, color={0,0,127}));
  connect(clock.y, greater1.u1) annotation (Line(points={{-149,70},{-144,70},{-144,
          -10},{-132,-10}}, color={0,0,127}));
  connect(greater1.y, switch_Q_total1.u2) annotation (Line(points={{-109,-10},{118,
          -10}},                     color={255,0,255}));
  connect(sensorBus.m_flow_boilerDrum, FWpump.u) annotation (Line(
      points={{-29.9,-99.9},{14,-99.9},{14,-80},{178,-80}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(actuatorBus.FWpump_m_flow, FWpump.y) annotation (Line(
      points={{30.1,-99.9},{280,-99.9},{280,-80},{201,-80}},
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
    Diagram(coordinateSystem(extent={{-180,-100},{280,200}})));
end CS_v2;
