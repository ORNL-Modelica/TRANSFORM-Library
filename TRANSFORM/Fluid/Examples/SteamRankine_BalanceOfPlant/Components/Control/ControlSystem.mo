within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control;
model ControlSystem "Plant control system"
  extends Templates.ControlSystem(
    u_valve_preheatHP(y=fWH_HP_level.y),
    u_pumpspeed_LP_1(y=condenserLevel.y),
    u_pumpspeed_LP_2(y=condenserLevel.y),
    u_pumpspeed_LP_3(y=condenserLevel.y),
    u_pumpspeed_IP(y=fWH_LP_level.y),
    u_TControlValve(y=steamPressure.y),
    u_pumpspeed_HP_1(y=1200),
    u_pumpspeed_HP_2(y=1200),
    u_pumpspeed_HP_3(y=1200),
    u_FWControlValve_1(y=drumLevel_SG_1.y),
    u_FWControlValve_2(y=drumLevel_SG_2.y),
    u_FWControlValve_3(y=drumLevel_SG_3.y),
    u_MSRControlLevelValve_1(y=mSR_levelFF.y),
    u_TBypassValve_1(y=uu_TBypassValve_1.y));

  replaceable DrumLevelFF          drumLevel_SG_1 constrainedby
    Interfaces.DrumLevel
    annotation (choicesAllMatching=true,Placement(transformation(extent={{-2,-230},{-22,-210}})));
  replaceable CondenserLevelFF
                             condenserLevel constrainedby
    Interfaces.CondenserLevel
    annotation (choicesAllMatching=true,Placement(transformation(extent={{68,-94},{48,-74}})));
  replaceable FWH_HP_levelFF
                           fWH_HP_level constrainedby Interfaces.CondenserLevel
    annotation (choicesAllMatching=true,Placement(transformation(extent={{-60,-94},{-80,-74}})));
  replaceable FWH_LP_levelFF
                           fWH_LP_level constrainedby Interfaces.CondenserLevel
    annotation (choicesAllMatching=true,Placement(transformation(extent={{12,-94},{-8,-74}})));
  replaceable DrumLevelFF          drumLevel_SG_2 constrainedby
    Interfaces.DrumLevel
    annotation (choicesAllMatching=true,Placement(transformation(extent={{-2,-186},{-22,-166}})));
  replaceable DrumLevelFF          drumLevel_SG_3 constrainedby
    Interfaces.DrumLevel
    annotation (choicesAllMatching=true,Placement(transformation(extent={{-2,-140},{-22,-120}})));
  replaceable SteamPressure steamPressure constrainedby
    Interfaces.SteamPressure
    annotation (choicesAllMatching=true,Placement(transformation(extent={{68,-140},{48,-120}})));
  replaceable MSR_levelFF mSR_levelFF constrainedby Interfaces.CondenserLevel
    annotation (Placement(transformation(extent={{116,-94},{96,-74}})));
  Modelica.Blocks.Sources.Trapezoid uu_TBypassValve_1(
    amplitude=0.5,
    rising=900,
    width=1800,
    falling=900,
    period=7200,
    nperiod=1,
    startTime=36000) annotation (Placement(transformation(extent={{-220,
            20},{-200,40}})));
equation

  connect(controlBus_Rankine.y_FWH_HP_level, fWH_HP_level.u_m_level)
    annotation (Line(
      points={{-100.1,-29.9},{-102,-29.9},{-102,-66},{-50,-66},{-50,-84},{-54,
          -84},{-54,-83.4},{-58.6,-83.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_Rankine.y_FWH_LP_level, fWH_LP_level.u_m_level)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-29.9},{-100.1,-68},{-100.1,-66},{22,-66},
          {22,-83.4},{13.4,-83.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_SteamGenerator1.y_drum_level, drumLevel_SG_1.u_m_level)
    annotation (Line(
      points={{-100.1,-221.9},{-100.1,-240},{6,-240},{6,-219.4},{-0.6,-219.4}},
      color={255,204,51},
      thickness=0.5));

  connect(controlBus_SteamGenerator1.y_drum_steamFlow, drumLevel_SG_1.u_m_steamFlow)
    annotation (Line(
      points={{-100.1,-221.9},{-100.1,-221.9},{-100.1,-240},{-12,-240},{-12,
          -231.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_SteamGenerator1.y_drum_FeedWaterFlow, drumLevel_SG_1.u_m_feedwater)
    annotation (Line(
      points={{-100.1,-221.9},{-100.1,-221.9},{-100.1,-240},{-6.4,-240},{-6.4,
          -231.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_SteamGenerator2.y_drum_level, drumLevel_SG_2.u_m_level)
    annotation (Line(
      points={{-100.1,-173.9},{-100,-173.9},{-100,-198},{6,-198},{6,-175.4},{
          -0.6,-175.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_SteamGenerator2.y_drum_steamFlow, drumLevel_SG_2.u_m_steamFlow)
    annotation (Line(
      points={{-100.1,-173.9},{-100.1,-198},{-12,-198},{-12,-187.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_SteamGenerator2.y_drum_FeedWaterFlow, drumLevel_SG_2.u_m_feedwater)
    annotation (Line(
      points={{-100.1,-173.9},{-100.1,-198},{-6.4,-198},{-6.4,-187.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_SteamGenerator3.y_drum_level, drumLevel_SG_3.u_m_level)
    annotation (Line(
      points={{-100.1,-129.9},{-100.1,-129.9},{-100.1,-150},{6,-150},{6,
          -129.4},{-0.6,-129.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_SteamGenerator3.y_drum_steamFlow, drumLevel_SG_3.u_m_steamFlow)
    annotation (Line(
      points={{-100.1,-129.9},{-100.1,-150},{-12,-150},{-12,-141.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_SteamGenerator3.y_drum_FeedWaterFlow, drumLevel_SG_3.u_m_feedwater)
    annotation (Line(
      points={{-100.1,-129.9},{-100.1,-150},{-6.4,-150},{-6.4,-141.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_Rankine.y_Condenser_level, condenserLevel.u_m_level)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-66},{78,-66},{78,-83.4},{69.4,-83.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_Rankine.y_TurbineHeader_pressure, steamPressure.u_m_pressure)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-106},{80,-106},{80,-129.4},{69.4,-129.4}},
      color={255,204,51},
      thickness=0.5));

  connect(controlBus_Rankine.y_FWH_HP_flow_in, fWH_HP_level.u_m_flowIn)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-29.9},{-100.1,-106},{-70,-106},{-70,
          -95.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_Rankine.y_FWH_HP_flow_out, fWH_HP_level.u_m_flowOut)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-29.9},{-100.1,-106},{-63,-106},{-63,
          -95.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_Rankine.y_FWH_LP_flow_in, fWH_LP_level.u_m_flowIn)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-29.9},{-100.1,-106},{2,-106},{2,-95.4}},
      color={255,204,51},
      thickness=0.5));

  connect(controlBus_Rankine.y_FWH_LP_flow_out, fWH_LP_level.u_m_flowOut)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-29.9},{-100.1,-106},{9,-106},{9,-95.4}},
      color={255,204,51},
      thickness=0.5));

  connect(controlBus_Rankine.y_FWH_LP_flow_out, condenserLevel.u_m_flowOut)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-106},{65,-106},{65,-95.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_Rankine.y_Condenser_flow_in, condenserLevel.u_m_flowIn)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-29.9},{-100.1,-106},{58,-106},{58,-95.4}},
      color={255,204,51},
      thickness=0.5));

  connect(controlBus_Rankine.y_FWH_HP_Valve_dp, fWH_HP_level.u_m_dp)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-29.9},{-100.1,-106},{-77,-106},{-77,
          -95.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_Rankine.y_FWH_LP_Pump_dp, fWH_LP_level.u_m_dp)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-29.9},{-100.1,-106},{-5,-106},{-5,-95.4}},
      color={255,204,51},
      thickness=0.5));

  connect(controlBus_Rankine.y_CondenserPump_dp, condenserLevel.u_m_dp)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-106},{51,-106},{51,-95.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_Rankine.y_FWControlValve_3_dp, drumLevel_SG_3.u_m_dp)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-29.9},{-100.1,-110},{-100.1,-108},{-30,
          -108},{-30,-146},{-17.8,-146},{-17.8,-141.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_Rankine.y_FWControlValve_2_dp, drumLevel_SG_2.u_m_dp)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-29.9},{-100.1,-110},{-28,-110},{-28,
          -192},{-17.8,-192},{-17.8,-187.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_Rankine.y_FWControlValve_1_dp, drumLevel_SG_1.u_m_dp)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-112},{-32,-112},{-32,-236},{-17.8,-236},
          {-17.8,-231.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_Rankine.y_MSR_level, mSR_levelFF.u_m_level) annotation (
      Line(
      points={{-100.1,-29.9},{-100.1,-66},{126,-66},{126,-83.4},{117.4,-83.4}},
      color={255,204,51},
      thickness=0.5));

  connect(controlBus_Rankine.y_MSR_Valve_dp, mSR_levelFF.u_m_dp) annotation (
      Line(
      points={{-100.1,-29.9},{-100.1,-106},{99,-106},{99,-95.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_Rankine.y_MSR_flow_in, mSR_levelFF.u_m_flowIn)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-106},{106,-106},{106,-95.4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus_Rankine.y_MSR_flow_out, mSR_levelFF.u_m_flowOut)
    annotation (Line(
      points={{-100.1,-29.9},{-100.1,-106},{113,-106},{113,-95.4}},
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
