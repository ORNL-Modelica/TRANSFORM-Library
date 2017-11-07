within TRANSFORM.Fluid.Pipes.BaseClasses;
model PipeWithWallIcons

  annotation (Icon(graphics={
        Rectangle(
          extent={{-86,40},{86,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          visible=DynamicSelect(true, if figure == 1 then true else false)),
        Rectangle(
          extent={{-86,-32},{86,-40}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-86,40},{86,32}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Backward)}));
end PipeWithWallIcons;
