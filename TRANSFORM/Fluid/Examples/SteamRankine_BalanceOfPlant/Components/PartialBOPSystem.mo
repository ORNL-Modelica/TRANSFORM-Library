within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components;
partial model PartialBOPSystem " Plant"
  package WaterMedium =
      Modelica.Media.Water.StandardWater;
  Control.ControlSystem controlSystem
    annotation (Placement(transformation(extent={{54,-96},{74,-76}})));
  Records.NominalData data
    annotation (Placement(transformation(extent={{38,10},{58,30}})));
  replaceable
    TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.SteamGeneratorVariableHeatLoad
    SG_1(redeclare package Medium = WaterMedium) constrainedby
    TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.PartialSteamGenerator
    annotation (Placement(transformation(extent={{-88,2},{-58,36}})));
  replaceable
    TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.SteamGeneratorVariableHeatLoad
    SG_2(redeclare package Medium = WaterMedium) constrainedby
    TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.PartialSteamGenerator
    annotation (Placement(transformation(extent={{-88,-44},{-58,-10}})));
  replaceable
    TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.SteamGeneratorVariableHeatLoad
    SG_3(redeclare package Medium = WaterMedium) constrainedby
    TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.PartialSteamGenerator
    annotation (Placement(transformation(extent={{-88,-86},{-58,-52}})));
  // above here needs to be visited
  Real total_Q_MW;
  Modelica.SIunits.HeatFlowRate total_Q=total_Q_MW*1e6;
  Real netEfficiency=steamCycle.generator.power
      /max(sum(total_Q),1e-6)*100;
  TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Rankine steamCycle(
      redeclare package Medium = WaterMedium)
    annotation (Placement(transformation(extent={{-8,-56},{68,-12}})));
  TRANSFORM.Utilities.Visualizers.displayReal PowerOutput(         precision=2,
      val=steamCycle.generator.power/1000000)
    annotation (Placement(transformation(extent={{-90,78},{-70,98}})));
  TRANSFORM.Utilities.Visualizers.displayReal PowerOutput2(precision=1, val=SG_1.drum_level_percentage)
    annotation (Placement(transformation(extent={{-150,-118},{-130,-98}})));
  TRANSFORM.Utilities.Visualizers.displayReal PowerOutput3(
      precision=1, val=steamCycle.condenser_level_percentage)
    annotation (Placement(transformation(extent={{-150,-42},{-130,-22}})));
  TRANSFORM.Utilities.Visualizers.displayReal PowerOutput4(
      precision=1, val=steamCycle.dearator_level_percentage)
    annotation (Placement(transformation(extent={{-150,-74},{-130,-54}})));
  TRANSFORM.Utilities.Visualizers.displayReal PowerOutput5(
      precision=1, val=steamCycle.preheater_LP_level_percentage)
    annotation (Placement(transformation(extent={{-150,-58},{-130,-38}})));
  TRANSFORM.Utilities.Visualizers.displayReal PowerOutput6(
      precision=1, val=steamCycle.preheater_HP_level_percentage)
    annotation (Placement(transformation(extent={{-150,-88},{-130,-68}})));
  TRANSFORM.Utilities.Visualizers.displayReal PowerOutput7(precision=1, val=
        steamCycle.feed_SG1.m_flow + steamCycle.feed_SG2.m_flow + steamCycle.feed_SG3.m_flow)
    annotation (Placement(transformation(extent={{-150,24},{-130,44}})));
  TRANSFORM.Utilities.Visualizers.displayReal PowerOutput8(precision=1, val=
        steamCycle.condenser.portSteamFeed.m_flow)
    annotation (Placement(transformation(extent={{-150,10},{-130,30}})));
  TRANSFORM.Utilities.Visualizers.displayReal PowerOutput9(precision=1, val=
        steamCycle.FWH_LP.portCoolant_a.m_flow)
    annotation (Placement(transformation(extent={{-150,-4},{-130,16}})));
  TRANSFORM.Utilities.Visualizers.displayReal PowerOutput10(precision=1, val=
        steamCycle.FWH_HP.portCoolant_a.m_flow)
    annotation (Placement(transformation(extent={{-150,-18},{-130,2}})));
  TRANSFORM.Utilities.Visualizers.displayReal Aheat2(precision=1, val=
        total_Q_MW)                                         annotation (
      Placement(transformation(extent={{-48,78},{-28,98}}, rotation=0)));
  TRANSFORM.Utilities.Visualizers.displayReal Aheat1(precision=1, val=steamCycle.header.medium.p
        *1e-5) annotation (Placement(transformation(extent={{-10,78},{10,98}},
          rotation=0)));
  TRANSFORM.Utilities.Visualizers.displayReal Aheat3(val=steamCycle.condenser.medium.p
        *1e-5, precision=4)
    annotation (Placement(transformation(extent={{26,78},{46,98}},   rotation=0)));
  TRANSFORM.Utilities.Visualizers.displayReal PowerOutput1(precision=1, val=
        steamCycle.header.medium.T - 273.15)
    annotation (Placement(transformation(extent={{-150,62},{-130,82}})));
  TRANSFORM.Utilities.Visualizers.displayReal PowerOutput13(precision=1, val=
        steamCycle.vol_preheater_HP.medium.T - 273.15)
    annotation (Placement(transformation(extent={{-150,46},{-130,66}})));
  TRANSFORM.Utilities.Visualizers.displayReal Aheat4(val=SG_1.drum.x_abs_riser,
      precision=2) annotation (Placement(transformation(extent={{64,78},{84,98}},
          rotation=0)));
  TRANSFORM.Utilities.Visualizers.displayReal PowerOutput12(       precision=2, val=
        netEfficiency)
    annotation (Placement(transformation(extent={{-48,58},{-28,78}})));
  TRANSFORM.Utilities.Visualizers.displayReal PowerOutput14(
                                                  precision=1, val=SG_2.drum_level_percentage)
    annotation (Placement(transformation(extent={{-150,-134},{-130,-114}})));
  TRANSFORM.Utilities.Visualizers.displayReal PowerOutput15(
                                                  precision=1, val=SG_3.drum_level_percentage)
    annotation (Placement(transformation(extent={{-150,-150},{-130,-130}})));
  TRANSFORM.Utilities.Visualizers.displayReal Aheat5(                     precision=2, val=
        steamCycle.HPT.stage2.x_abs_out)
    annotation (Placement(transformation(extent={{96,78},{116,98}},rotation=0)));
  TRANSFORM.Utilities.Visualizers.displayReal PowerOutput16(
      precision=1, val=steamCycle.MSR_level_percentage)
    annotation (Placement(transformation(extent={{-150,-104},{-130,-84}})));
  TRANSFORM.Utilities.Visualizers.displayReal PowerOutput17(
                                                  precision=1, val=
        steamCycle.MSR.summary.T_main_steam_out - 273.15)
    annotation (Placement(transformation(extent={{-150,76},{-130,96}})));
equation
  connect(steamCycle.controlBus, controlSystem.controlBus_Rankine) annotation (
      Line(
      points={{27.7545,-52.8571},{27.7545,-83.6471},{54,-83.6471}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(SG_1.controlBus, controlSystem.controlBus_SteamGenerator1)
    annotation (Line(
      points={{-73,2},{-106,2},{-106,-94},{54.1429,-94},{54.1429,-94.4706}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(SG_2.controlBus, controlSystem.controlBus_SteamGenerator2)
    annotation (Line(
      points={{-73,-44},{-106,-44},{-106,-44},{-106,-92},{54,-92},{54,-90.8235}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlSystem.controlBus_SteamGenerator3, SG_3.controlBus)
    annotation (Line(
      points={{54.1429,-87.4118},{54.1429,-86},{-73,-86}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(SG_3.drain_steam, steamCycle.feed_SG3) annotation (Line(
      points={{-58,-59.4182},{-28,-59.4182},{-28,-26.1429},{-8,-26.1429}},
      color={0,127,255},
      thickness=0.5));
  connect(SG_2.drain_steam, steamCycle.feed_SG2) annotation (Line(
      points={{-58,-17.4182},{-34,-17.4182},{-34,-20.1714},{-8,-20.1714}},
      color={0,127,255},
      thickness=0.5));
  connect(SG_1.drain_steam, steamCycle.feed_SG1) annotation (Line(
      points={{-58,28.5818},{-44,28.5818},{-44,28},{-20,28},{-20,-13.5714},{
          -7.82727,-13.5714}},
      color={0,127,255},
      thickness=0.5));
  connect(SG_3.port_feedWater, steamCycle.drain_to_SG3) annotation (Line(
      points={{-58,-79.8182},{-16,-79.8182},{-16,-51.2857},{-7.82727,-51.2857}},
      color={0,127,255},
      thickness=0.5));
  connect(SG_2.port_feedWater, steamCycle.drain_to_SG2) annotation (Line(
      points={{-58,-37.8182},{-34,-37.8182},{-34,-43.4286},{-7.82727,-43.4286}},
      color={0,127,255},
      thickness=0.5));
  connect(SG_1.port_feedWater, steamCycle.drain_to_SG1) annotation (Line(
      points={{-58,8.18182},{-46,8.18182},{-46,8},{-20,8},{-20,-35.5714},{
          -7.82727,-35.5714}},
      color={0,127,255},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -160},{140,100}}), graphics={
        Rectangle(
          extent={{-106,96},{130,54}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          radius=2),                             Text(
          extent={{-102,86},{-58,74}},
          lineColor={0,0,0},
          textString="Generated power [MWe]"),
        Rectangle(
          extent={{-158,-20},{-114,-146}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          radius=2),                             Text(
          extent={{-154,-98},{-120,-104}},
          lineColor={0,0,0},
          textString="SG1 drum level [%%]"),     Text(
          extent={{-154,-22},{-120,-28}},
          lineColor={0,0,0},
          textString="condenser level [%%]"),    Text(
          extent={{-154,-54},{-124,-60}},
          lineColor={0,0,0},
          textString="dearator level [%%]"),     Text(
          extent={{-154,-38},{-120,-44}},
          lineColor={0,0,0},
          textString="LP preheater level [%%]"), Text(
          extent={{-154,-68},{-120,-74}},
          lineColor={0,0,0},
          textString="HP preheater level [%%]"),
        Rectangle(
          extent={{-158,48},{-110,-16}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          radius=2),                             Text(
          extent={{-156,44},{-122,38}},
          lineColor={0,0,0},
          textString="HP steam flow [kg/s]"),    Text(
          extent={{-156,30},{-112,24}},
          lineColor={0,0,0},
          textString="condenser steam flow[kg/s]"),
                                                 Text(
          extent={{-156,16},{-114,10}},
          lineColor={0,0,0},
          textString="LP preheater cooling flow [kg/s]"),
                                                 Text(
          extent={{-156,2},{-114,-4}},
          lineColor={0,0,0},
          textString="HP preheater cooling flow [kg/s]"),
                              Text(
          extent={{-52,84},{-20,76}},
          lineColor={0,0,0},
          textString="heat boiler [MW]"),
                              Text(
          extent={{-16,84},{16,76}},
          lineColor={0,0,0},
          textString="steam pressure [bar]"),
                              Text(
          extent={{20,84},{52,76}},
          lineColor={0,0,0},
          textString="condenser pressure [bar]"),
        Rectangle(
          extent={{-158,96},{-120,50}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          radius=2),                             Text(
          extent={{-152,82},{-126,76}},
          lineColor={0,0,0},
          textString="T HP steam  [C]"),         Text(
          extent={{-152,66},{-128,60}},
          lineColor={0,0,0},
          textString="T feedwater [C]"),
                              Text(
          extent={{58,84},{90,76}},
          lineColor={0,0,0},
          textString="drum riser quality [%%]"), Text(
          extent={{-60,62},{-12,58}},
          lineColor={0,0,0},
          textString="Net efficiency [%%]"),     Text(
          extent={{-154,-114},{-120,-120}},
          lineColor={0,0,0},
          textString="SG2 drum level [%%]"),     Text(
          extent={{-154,-130},{-120,-136}},
          lineColor={0,0,0},
          textString="SG3 drum level [%%]"),
                              Text(
          extent={{96,84},{120,76}},
          lineColor={0,0,0},
          textString="HPT quality [%%]"),        Text(
          extent={{-160,-84},{-114,-90}},
          lineColor={0,0,0},
          textString="MSR level [%%]"),          Text(
          extent={{-152,96},{-126,90}},
          lineColor={0,0,0},
          textString="T LP steam  [C]")}),
    experiment(
      StopTime=25000,
      __Dymola_NumberOfIntervals=5000,
      Tolerance=1e-005),
    __Dymola_experimentSetupOutput(equidistant=false),
    Icon(coordinateSystem(extent={{-160,-160},{140,100}}), graphics={
        Polygon(
          points={{24,-62},{24,-62}},
          lineColor={105,149,214},
          fillColor={105,149,214},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<h4>Description</h4>
<p>This is an example model of an over-critical coal fired 400 MWe powerplant including a control system. It covers the whole steam cycle and a large part of the fluegas line with air pre-heater and coal combustion.</p>
<h4>Output</h4>
<p>The sub component models include visualization elements for a better overview of the system.</p>
</html>", revisions=""),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=false,
      OutputFlatModelica=false));
end PartialBOPSystem;
