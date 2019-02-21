within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control.Templates;
model ControlSystem "Plant control system"
  ControlBuses.ControlBus_Rankine_controlsystem controlBus_Rankine annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,-30})));
  Modelica.Blocks.Sources.RealExpression valve_HP(y=1)
    annotation (Placement(transformation(extent={{-62,-22},{-78,-6}})));
  Modelica.Blocks.Sources.RealExpression valve_IP(y=1)
    annotation (Placement(transformation(extent={{8,-22},{-8,-6}})));
  Modelica.Blocks.Sources.RealExpression valve_LP(y=1)
    annotation (Placement(transformation(extent={{76,-22},{60,-6}})));
  Records.NominalData data
    annotation (Placement(transformation(extent={{144,52},{164,72}})));
  ControlBuses.ControlBus_SteamGenerator_controlsystem controlBus_SteamGenerator1
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,-222}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-98,-214})));
  Records.BoilerNominalValues boilerNominalValues
    annotation (Placement(transformation(extent={{144,22},{164,42}})));
  ControlBuses.ControlBus_SteamGenerator_controlsystem controlBus_SteamGenerator2
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,-174}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,-152})));
  ControlBuses.ControlBus_SteamGenerator_controlsystem controlBus_SteamGenerator3
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-100,-130}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-98,-94})));
  Modelica.Blocks.Sources.RealExpression u_MSIValve_SG1(y=1)
    annotation (Placement(transformation(extent={{-50,-150},{-66,-134}})));
  Modelica.Blocks.Sources.RealExpression u_MSIValve_SG2(y=1)
    annotation (Placement(transformation(extent={{-52,-194},{-68,-178}})));
  Modelica.Blocks.Sources.RealExpression u_MSIValve_SG3(y=1) annotation (Placement(
        transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-58,-232})));
  Modelica.Blocks.Sources.RealExpression u_SGBlockValve_SG1(y=1)
    annotation (Placement(transformation(extent={{-50,-128},{-66,-112}})));
  Modelica.Blocks.Sources.RealExpression u_SGBlockValve_SG2(y=1)
    annotation (Placement(transformation(extent={{-52,-172},{-68,-156}})));
  Modelica.Blocks.Sources.RealExpression u_SGBlockValve_SG3(y=1) annotation (
      Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-58,-212})));
  Modelica.Blocks.Sources.RealExpression u_TStopValve(y=1)
    annotation (Placement(transformation(extent={{-62,80},{-78,96}})));
  Modelica.Blocks.Sources.RealExpression u_TBypassValve_1(y=0)
    annotation (Placement(transformation(extent={{6,78},{-10,94}})));
  Modelica.Blocks.Sources.RealExpression u_TBypassValve_2(y=0)
    annotation (Placement(transformation(extent={{76,78},{60,94}})));
  Modelica.Blocks.Sources.RealExpression u_TControlValve(y=
        0.5)
    annotation (Placement(transformation(extent={{140,78},{124,94}})));
  Modelica.Blocks.Sources.RealExpression u_FWIsolationValve_1(y=1)
    annotation (Placement(transformation(extent={{-62,58},{-78,74}})));
  Modelica.Blocks.Sources.RealExpression u_FWIsolationValve_2(y=1)
    annotation (Placement(transformation(extent={{6,58},{-10,74}})));
  Modelica.Blocks.Sources.RealExpression u_FWIsolationValve_3(y=1)
    annotation (Placement(transformation(extent={{76,58},{60,74}})));
  Modelica.Blocks.Sources.RealExpression u_FWBypassValve_1(y=
        0)
    annotation (Placement(transformation(extent={{-62,38},{-78,54}})));
  Modelica.Blocks.Sources.RealExpression u_FWBypassValve_2(y=
        0)
    annotation (Placement(transformation(extent={{6,38},{-10,54}})));
  Modelica.Blocks.Sources.RealExpression u_FWBypassValve_3(y=
        0)
    annotation (Placement(transformation(extent={{76,38},{60,54}})));
  Modelica.Blocks.Sources.RealExpression u_FWBlockValve_1(y=1)
    annotation (Placement(transformation(extent={{-62,18},{-78,34}})));
  Modelica.Blocks.Sources.RealExpression u_FWBlockValve_2(y=1)
    annotation (Placement(transformation(extent={{6,16},{-10,32}})));
  Modelica.Blocks.Sources.RealExpression u_FWBlockValve_3(y=1)
    annotation (Placement(transformation(extent={{76,16},{60,32}})));
  Modelica.Blocks.Sources.RealExpression u_FWControlValve_1(y=
        1) annotation (Placement(transformation(extent={{-62,-2},{-78,14}})));
  Modelica.Blocks.Sources.RealExpression u_FWControlValve_2(y=
        1) annotation (Placement(transformation(extent={{6,-2},{-10,14}})));
  Modelica.Blocks.Sources.RealExpression u_FWControlValve_3(y=
        1) annotation (Placement(transformation(extent={{76,-2},{60,14}})));
  Modelica.Blocks.Sources.RealExpression u_pumpspeed_HP_1(y=
        920)
           annotation (Placement(transformation(extent={{8,-42},{-8,-26}})));
  Modelica.Blocks.Sources.RealExpression u_pumpspeed_HP_2(y=
        920)
           annotation (Placement(transformation(extent={{76,-42},{60,-26}})));
  Modelica.Blocks.Sources.RealExpression u_pumpspeed_HP_3(y=
        920)
           annotation (Placement(transformation(extent={{142,-42},{126,-26}})));
  Modelica.Blocks.Sources.RealExpression u_pumpspeed_IP(y=
        1255)
    annotation (Placement(transformation(extent={{-62,-62},{-78,-46}})));
  Modelica.Blocks.Sources.RealExpression u_pumpspeed_LP_1(y=
        1200)
           annotation (Placement(transformation(extent={{8,-62},{-8,-46}})));
  Modelica.Blocks.Sources.RealExpression u_pumpspeed_LP_2(y=
        1200)
           annotation (Placement(transformation(extent={{76,-62},{60,-46}})));
  Modelica.Blocks.Sources.RealExpression u_pumpspeed_LP_3(y=
        1200)
           annotation (Placement(transformation(extent={{142,-62},{126,-46}})));
  Modelica.Blocks.Sources.RealExpression u_valve_preheatHP(y=
        0.6)
           annotation (Placement(transformation(extent={{-62,-40},{-78,-24}})));
  Modelica.Blocks.Sources.RealExpression u_MSRControlLevelValve_1(y=
        0.3)
    annotation (Placement(transformation(extent={{140,58},{124,74}})));
  Modelica.Blocks.Sources.RealExpression u_MSRControlValve_1(y=
        1)
    annotation (Placement(transformation(extent={{140,38},{124,54}})));
  Modelica.Blocks.Sources.RealExpression u_TValve_LPT_1(y=
        1)
    annotation (Placement(transformation(extent={{140,16},{124,32}})));
  Modelica.Blocks.Sources.RealExpression u_TValve_LPT_2(y=
        1)
    annotation (Placement(transformation(extent={{140,-2},{124,14}})));
equation
  connect(controlBus_Rankine.u_valve_HP, valve_HP.y) annotation (Line(
      points={{-100.1,-29.9},{-100,-29.9},{-100,-28},{-100,-14},{-78.8,-14}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_valve_IP, valve_IP.y) annotation (Line(
      points={{-100.1,-29.9},{-100,-29.9},{-100,-22},{-12,-22},{-12,-14},{-8.8,-14}},
      color={255,204,51},
      thickness=0.5),            Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_valve_LP, valve_LP.y) annotation (Line(
      points={{-100.1,-29.9},{-100.1,-36},{-100,-36},{-100,-22},{38,-22},{38,-14},
          {59.2,-14}},
      color={255,204,51},
      thickness=0.5),            Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_SteamGenerator1.u_SGBlockValve, u_SGBlockValve_SG3.y)
    annotation (Line(
      points={{-100.1,-221.9},{-100.1,-212},{-66.8,-212}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_SteamGenerator1.u_MSIValve, u_MSIValve_SG3.y) annotation (
      Line(
      points={{-100.1,-221.9},{-100.1,-232},{-66.8,-232}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_SteamGenerator2.u_SGBlockValve, u_SGBlockValve_SG2.y)
    annotation (Line(
      points={{-100.1,-173.9},{-102.1,-173.9},{-102.1,-164},{-68.8,-164}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_SteamGenerator2.u_MSIValve, u_MSIValve_SG2.y) annotation (
      Line(
      points={{-100.1,-173.9},{-100.1,-186},{-68.8,-186}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_SteamGenerator3.u_MSIValve, u_MSIValve_SG1.y) annotation (
      Line(
      points={{-100.1,-129.9},{-100.1,-142},{-66.8,-142}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_SteamGenerator3.u_SGBlockValve, u_SGBlockValve_SG1.y)
    annotation (Line(
      points={{-100.1,-129.9},{-100.1,-129.9},{-100.1,-120},{-66.8,-120}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_TBypassValve_1, u_TBypassValve_1.y) annotation (
      Line(
      points={{-100.1,-29.9},{-100.1,66},{-100,66},{-100,78},{-16,78},{-16,86},{
          -10.8,86}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_TBypassValve_2, u_TBypassValve_2.y) annotation (
      Line(
      points={{-100.1,-29.9},{-102,-29.9},{-102,76},{-102,78},{52,78},{52,86},{59.2,
          86}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_TControlValve, u_TControlValve.y) annotation (
      Line(
      points={{-100.1,-29.9},{-102,-29.9},{-102,78},{-100.1,78},{123.2,78},{123.2,
          86}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_FWIsolationValve_1, u_FWIsolationValve_1.y)
    annotation (Line(
      points={{-100.1,-29.9},{-102.1,-29.9},{-102.1,66},{-78.8,66}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_FWIsolationValve_2, u_FWIsolationValve_2.y)
    annotation (Line(
      points={{-100.1,-29.9},{-102,-29.9},{-102,58},{-18,58},{-18,66},{-10.8,66}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_FWIsolationValve_3, u_FWIsolationValve_3.y)
    annotation (Line(
      points={{-100.1,-29.9},{-102,-29.9},{-102,58},{54,58},{54,66},{59.2,66}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_FWBypassValve_1, u_FWBypassValve_1.y)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,46},{-78.8,46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_FWBypassValve_2, u_FWBypassValve_2.y)
    annotation (Line(
      points={{-100.1,-29.9},{-102,-29.9},{-102,38},{-14,38},{-14,46},{-10.8,46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_FWBlockValve_1, u_FWBlockValve_1.y) annotation (
      Line(
      points={{-100.1,-29.9},{-100.1,-29.9},{-100.1,26},{-78.8,26}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_FWBlockValve_2, u_FWBlockValve_2.y) annotation (
      Line(
      points={{-100.1,-29.9},{-102,-29.9},{-102,18},{-10,18},{-10,24},{-10.8,24}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_FWBlockValve_3, u_FWBlockValve_3.y) annotation (
      Line(
      points={{-100.1,-29.9},{-102,-29.9},{-102,18},{54,18},{54,24},{59.2,24}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_TStopValve, u_TStopValve.y) annotation (Line(
      points={{-100.1,-29.9},{-102,-29.9},{-102,90},{-102,88},{-78.8,88}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_FWBypassValve_3, u_FWBypassValve_3.y)
    annotation (Line(
      points={{-100.1,-29.9},{-102,-29.9},{-102,38},{54,38},{54,46},{59.2,46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_FWControlValve_1, u_FWControlValve_1.y)
    annotation (Line(
      points={{-100.1,-29.9},{-102,-29.9},{-102,6},{-78.8,6}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_FWControlValve_2, u_FWControlValve_2.y)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-2},{-10.8,-2},{-10.8,6}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_FWControlValve_3, u_FWControlValve_3.y)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-29.9},{-100.1,-2},{59.2,-2},{59.2,6}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_pumpspeed_HP[1], u_pumpspeed_HP_1.y) annotation (
     Line(
      points={{-100.1,-29.9},{-100.1,-42},{-8.8,-42},{-8.8,-34}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_pumpspeed_HP[2], u_pumpspeed_HP_2.y) annotation (
     Line(
      points={{-100.1,-29.9},{-100.1,-42},{52,-42},{52,-34},{59.2,-34}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_pumpspeed_HP[3], u_pumpspeed_HP_3.y) annotation (
     Line(
      points={{-100.1,-29.9},{-100.1,-42},{120,-42},{120,-34},{125.2,-34}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_pumpspeed_IP, u_pumpspeed_IP.y) annotation (Line(
      points={{-100.1,-29.9},{-100.1,-29.9},{-100.1,-52},{-100.1,-54},{-78.8,-54}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_pumpspeed_LP[1], u_pumpspeed_LP_1.y) annotation (
     Line(
      points={{-100.1,-29.9},{-100.1,-29.9},{-100.1,-62},{-12,-62},{-12,-54},{-8.8,
          -54}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_pumpspeed_LP[2], u_pumpspeed_LP_2.y) annotation (
     Line(
      points={{-100.1,-29.9},{-100,-29.9},{-100,-62},{56,-62},{56,-54},{59.2,-54}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_pumpspeed_LP[3], u_pumpspeed_LP_3.y) annotation (
     Line(
      points={{-100.1,-29.9},{-100.1,-62},{122,-62},{122,-54},{125.2,-54}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_valve_preheat_HP, u_valve_preheatHP.y)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-29.9},{-100.1,-32},{-78.8,-32}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_MSRLevelControlValve_1,
    u_MSRControlLevelValve_1.y) annotation (Line(
      points={{-100.1,-29.9},{-102,-29.9},{-102,58},{123.2,58},{123.2,66}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_MSRControlValve_1, u_MSRControlValve_1.y)
    annotation (Line(
      points={{-100.1,-29.9},{-102,-29.9},{-102,40},{-102,38},{123.2,38},{123.2,
          46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(controlBus_Rankine.u_TValve_LPT_1, u_TValve_LPT_1.y) annotation (
      Line(
      points={{-100.1,-29.9},{-102,-29.9},{-102,18},{123.2,18},{123.2,24}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_Rankine.u_TValve_LPT_2, u_TValve_LPT_2.y) annotation (
      Line(
      points={{-100.1,-29.9},{-102,-29.9},{-102,0},{-102,-2},{123.2,-2},{123.2,6}},
      color={255,204,51},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -240},{180,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-240},{180,100}}),
        graphics={
        Rectangle(
          extent={{-100,100},{180,-240}},
          lineColor={135,135,135},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,118},{180,106}},
          lineColor={0,0,0},
          textString="%name"),
        Text(
          extent={{74,14},{-4,-172}},
          lineColor={255,255,255},
          textString="C")}),
    Documentation(info="<html>
<h4>Description</h4>
<p>Example of a control system and load dependent boundary conditions, including a ramp function for the power controller to simulate load change and a load dependent load feedwater flow regulation.</p>
</html>",
      revisions="<html>
<!--copyright-->
</html>"));
end ControlSystem;
