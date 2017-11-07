within TRANSFORM.Icons;
partial package ElectricalPackage
  extends Icons.Package;

  annotation (Icon(graphics={
        Ellipse(
          extent={{60,60},{-60,-60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Sphere), Polygon(
          points={{4,42},{22,42},{2,14},{24,14},{-26,-42},{-2,2},{-16,2},{4,42}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));

end ElectricalPackage;
