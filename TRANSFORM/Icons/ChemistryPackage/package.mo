within TRANSFORM.Icons;
package ChemistryPackage
  extends TRANSFORM.Icons.Package;

  annotation (Icon(graphics={
        Ellipse(
          extent={{60,60},{-60,-60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Sphere), Polygon(
          points={{-10,50},{12,50},{12,42},{12,18},{14,10},{32,-28},{36,-36},{34,
              -42},{0,-46},{-32,-42},{-34,-36},{-30,-28},{-12,10},{-10,18},{-10,
              42},{-10,50}},
          smooth=Smooth.Bezier,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}));
end ChemistryPackage;
