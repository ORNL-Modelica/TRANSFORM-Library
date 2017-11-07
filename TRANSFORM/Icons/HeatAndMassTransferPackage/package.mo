within TRANSFORM.Icons;
partial package HeatAndMassTransferPackage
  extends Icons.Package;

  annotation (Icon(graphics={Ellipse(
          extent={{60,60},{-60,-60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Sphere), Polygon(
          points={{-16,-50},{-40,-22},{-28,0},{-4,24},{2,36},{0,42},{-2,46},{22,
              26},{20,-4},{14,-16},{14,-16},{22,-12},{26,-8},{24,0},{36,-20},{30,
              -40},{16,-50},{15.994,-49.9531},{18,-38},{10,-32},{14,-38},{6,-46},
              {6,-46},{10,-34},{2,-26},{-2,-14},{0,-8},{-18,-24},{-18,-42},{-16,
              -50}},
          smooth=Smooth.Bezier,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}));
end HeatAndMassTransferPackage;
