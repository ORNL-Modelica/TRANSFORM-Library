within TRANSFORM.Examples.GenericModular_PWR;
model CS_LoadFollow
  extends BaseClasses.Partial_ControlSystem;
  input SI.Power Q_total_setpoint "Setpoint reactor power" annotation(Dialog(group="Inputs"));
  TRANSFORM.Controls.LimPID PID_Q(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1e-3,
    k_s=1/data.Q_total,
    k_m=1/data.Q_total)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Data.Data_GenericModule data
    annotation (Placement(transformation(extent={{-10,-88},{10,-68}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Q_total_setpoint)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  TRANSFORM.Controls.LimPID PID_steam(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yb=data.m_flow_steam,
    k_s=1/data.dT_core,
    k_m=1/data.dT_core,
    yMax=1.2*data.m_flow_steam,
    yMin=0.8*data.m_flow_steam)
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=data.dT_core)
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
equation
  connect(actuatorBus.reactivity_CR, PID_Q.y) annotation (Line(
      points={{30.1,-99.9},{50,-99.9},{50,0},{11,0}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(sensorBus.Q_total, PID_Q.u_m) annotation (Line(
      points={{-29.9,-99.9},{-80,-99.9},{-80,-20},{0,-20},{0,-12}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(realExpression.y, PID_Q.u_s)
    annotation (Line(points={{-29,0},{-12,0}}, color={0,0,127}));
  connect(realExpression1.y, PID_steam.u_s)
    annotation (Line(points={{-29,-40},{-12,-40}}, color={0,0,127}));
  connect(actuatorBus.m_flow_steam, PID_steam.y) annotation (Line(
      points={{30.1,-99.9},{50,-99.9},{50,-40},{11,-40}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(sensorBus.dT_core, PID_steam.u_m) annotation (Line(
      points={{-29.9,-99.9},{-80,-99.9},{-80,-60},{0,-60},{0,-52}},
      color={239,82,82},
      pattern=LinePattern.Dash,
      thickness=0.5));
annotation(defaultComponentName="PHS_CS", Icon(graphics={
        Text(
          extent={{-94,82},{94,74}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,237},
          fillPattern=FillPattern.Solid,
          textString="Change Me")}));
end CS_LoadFollow;
