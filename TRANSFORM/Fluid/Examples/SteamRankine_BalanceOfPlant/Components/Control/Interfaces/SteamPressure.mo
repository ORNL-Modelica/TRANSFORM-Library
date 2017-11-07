within TRANSFORM.Fluid.Examples.SteamRankine_BalanceOfPlant.Components.Control.Interfaces;
partial block SteamPressure "Steam pressure"
  extends Modelica.Blocks.Interfaces.SO;

  Modelica.Blocks.Interfaces.RealInput u_m_pressure "Measured pressure"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-128,-8},{-100,20}})));
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
end SteamPressure;
