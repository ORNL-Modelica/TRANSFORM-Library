within TRANSFORM.Examples.GenericModular_PWR;
model CS_Dummy
  extends BaseClasses.Partial_ControlSystem;
  Modelica.Blocks.Sources.RealExpression Reactivity_CR
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Blocks.Sources.RealExpression M_flow_steam(y=data.m_flow_steam)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Data.Data_GenericModule data
    annotation (Placement(transformation(extent={{-10,-88},{10,-68}})));
equation
  connect(actuatorBus.reactivity_CR, Reactivity_CR.y) annotation (Line(
      points={{30.1,-99.9},{50,-99.9},{50,-40},{11,-40}},
      color={111,216,99},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(actuatorBus.m_flow_steam, M_flow_steam.y) annotation (Line(
      points={{30.1,-99.9},{50,-99.9},{50,-60},{11,-60}},
      color={111,216,99},
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
end CS_Dummy;
