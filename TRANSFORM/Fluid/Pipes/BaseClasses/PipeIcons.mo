within TRANSFORM.Fluid.Pipes.BaseClasses;
partial model PipeIcons

  parameter Integer figure=1 "Index for Icon figure" annotation (choices(
      choice=1 "Pipe",
      choice=2 "Annulus",
      choice=3 "Duct"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-60,40},{-90,-40}},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder,
          lineColor={0,0,0},
          visible=DynamicSelect(true, if figure == 1 then true else false)),
        Rectangle(
          extent={{-76,40},{76,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          visible=DynamicSelect(true, if figure == 1 then true else false)),
        Ellipse(
          extent={{90,40},{60,-40}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          visible=DynamicSelect(true, if figure == 1 then true else false)),
        Ellipse(
          extent={{-60,40},{-90,-40}},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder,
          lineColor={0,0,0},
          visible=DynamicSelect(true, if figure == 2 then true else false)),
        Rectangle(
          extent={{-74,40},{74,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          visible=DynamicSelect(true, if figure == 2 then true else false)),
        Ellipse(
          extent={{90,40},{60,-40}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Sphere,
          lineColor={0,0,0},
          visible=DynamicSelect(true, if figure == 2 then true else false)),
        Ellipse(
          extent={{82,20},{70,-20}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(true, if figure == 2 then true else false)),
        Rectangle(
          extent={{-88,20},{40,-40}},
          lineColor={0,0,0},
          fillColor={0,93,186},
          fillPattern=FillPattern.Solid,
          visible=DynamicSelect(true, if figure == 3 then true else false)),
        Polygon(
          points={{-88,20},{-40,40},{88,40},{40,20},{-88,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,93,186},
          visible=DynamicSelect(true, if figure == 3 then true else false)),
        Polygon(
          points={{40,-40},{88,-20},{88,40},{40,20},{40,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,115,230},
          visible=DynamicSelect(true, if figure == 3 then true else false)),
        Polygon(
          points={{78,22},{78,-12},{52,-22},{52,12},{78,22}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={175,175,175},
          visible=DynamicSelect(true, if figure == 3 then true else false))}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
end PipeIcons;
