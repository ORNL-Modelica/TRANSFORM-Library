within TRANSFORM.Math.Easing;
model check_easeInCubic

  Real d = 5;
  Real b = 3;
  Real c = 7;

  Real t = time/d;

  Real valin = TRANSFORM.Math.Easing.easeInCubic(t);
  Real valout = TRANSFORM.Math.Easing.easeOutCubic(t);
  Real yin, yout;
equation
    yin = b + valin*(c-b);
    yout = b + valout*(c-b);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10));
end check_easeInCubic;
