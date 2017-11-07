within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control.Interfaces;
partial block DrumLevel "Drum level interface"
  extends Modelica.Blocks.Interfaces.SO;
  parameter Boolean enable_dpSignal=true "Enable differential pressure connector" annotation(Evaluate=true, HideResult=true, choices(checkBox=true),Dialog(group="Configuration"));

  Modelica.Blocks.Interfaces.RealInput u_m_level "Measured level" annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-128,-8},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput u_m_steamFlow "Measured steam flow"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={6,-120}),  iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=90,
        origin={0,-114})));
  Modelica.Blocks.Interfaces.RealInput u_m_feedwater
    "Measured feedwater flow"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-120}), iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=90,
        origin={-56,-114})));
  Modelica.Blocks.Interfaces.RealInput u_m_dp if enable_dpSignal
    "Measured differential pressure over control actuator" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={76,-120}), iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=90,
        origin={58,-114})));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{36,68},{-40,-74}},
          lineColor={255,255,255},
          textString="C")}));
end DrumLevel;
