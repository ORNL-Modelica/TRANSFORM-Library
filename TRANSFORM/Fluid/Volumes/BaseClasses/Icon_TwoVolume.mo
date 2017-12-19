within TRANSFORM.Fluid.Volumes.BaseClasses;
model Icon_TwoVolume

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Polygon(
          points={{5,75},{1,75},{-5,65},{-5,-65},{1,-75},{5,-75},{5,75}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          origin={95,-5},
          rotation=180),
        Rectangle(
          extent={{-90,70},{90,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,137},{102,107}},
          lineColor={0,0,0},
          textString="%name"),
        Polygon(
          points={{-40,20},{-40,20}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-166,78},{-166,78}},
          lineColor={0,0,0},
          smooth=Smooth.Bezier,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-90,-50},{90,-80}},
          lineColor={0,0,0},
          fillColor={0,122,236},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-90,70},{-94,70},{-100,60},{-100,-70},{-94,-80},{-90,-80},{
              -90,70}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}),                                             Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end Icon_TwoVolume;
