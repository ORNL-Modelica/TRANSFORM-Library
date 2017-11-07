within TRANSFORM.Icons;
partial package HeatExchangersPackage
  extends Icons.Package;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Line(points={{-156,102}}, color={0,0,0}),
        Ellipse(
          extent={{60,60},{-60,-60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Sphere),                                   Line(
            points={{-60,0},{-40,0},{-28,30},{0,-28},{26,30},{40,0},{60,0}},
                            color={255,255,255})}));
end HeatExchangersPackage;
