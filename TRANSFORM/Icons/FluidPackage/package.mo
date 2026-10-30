within TRANSFORM.Icons;
partial package FluidPackage
  extends Icons.Package;

annotation (Icon(graphics={
          Polygon(
          points={{0,60},{4,42},{10,26},{20,8},{28,-6},{36,-24},{32,-42},{20,-56},
              {0,-60},{-20,-56},{-34,-42},{-36,-24},{-28,-6},{-20,8},{-10,26},{-4,
              42},{0,60},{0,60}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier), Polygon(
          points={{18,-6},{18,-6},{26,-18},{28,-32},{22,-42},{14,-48},{14,-48},{
              20,-36},{22,-22},{18,-6}},
          smooth=Smooth.Bezier,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
      Line(
        points={{-60,-140},{-30,-120},{0,-140},{30,-160},{60,-140}},
        color={0,0,0},
        smooth=Smooth.Bezier)}));
end FluidPackage;
