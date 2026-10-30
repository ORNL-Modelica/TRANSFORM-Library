within TRANSFORM.Icons;
partial package ReactorKineticsPackage
  extends Icons.Package;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Line(points={{-80,-14},{-60,-14}}, color={0,0,0}),
        Line(
          points={{-60,-14},{-56,26},{-54,58},{-48,76},{-34,80},{-22,60},{-10,
            30},{2,6},{24,-20},{48,-38},{74,-52},{94,-56}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(points={{-80,-40},{-60,-40}}, color={0,0,255}),
        Line(
          points={{-60,-40},{-54,-16},{-46,16},{-36,30},{-18,-8},{4,-32},{32,-48},
              {68,-58},{94,-60}},
          color={0,0,255},
          smooth=Smooth.Bezier)}));
end ReactorKineticsPackage;
