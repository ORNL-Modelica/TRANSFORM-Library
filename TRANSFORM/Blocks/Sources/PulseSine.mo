within TRANSFORM.Blocks.Sources;
block PulseSine "Generate sine pulse signal of type Real"
  import Modelica.Constants.pi;
  parameter Real amplitude=1 "Amplitude of sine wave";
  parameter SI.Frequency f(start=1) "Frequency of sine wave";
  parameter SI.Angle phase=0 "Phase of sine wave";
  extends Modelica.Blocks.Interfaces.SignalSource;

equation

  if Modelica.Math.sin(2*pi*f*(time - startTime)) < 0 then
    y = offset;
  else
    y = offset + (if time < startTime then 0 else amplitude*Modelica.Math.sin(2*pi*f*(time -
      startTime)));
    // + phase));
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics={
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-70},{-40,-70},{-40,-70},{-34,44},{-6,44},{0,-70},{0,-70},{40,-70},{40,-70},
              {46,44},{74,44},{78,-70}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Text(extent={{-147,-152},{153,-112}}, textString="period=%period")}));
end PulseSine;
