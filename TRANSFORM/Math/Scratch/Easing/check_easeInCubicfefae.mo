within TRANSFORM.Math.Scratch.Easing;
model check_easeInCubicfefae

  Real d0 = 3.2;

  Real t = time/d0;

  Real y=TRANSFORM.Math.Scratch.Easing.easeInOutCubic(
      func2,
      func1,
      time - 3.2);
  Real valout = TRANSFORM.Math.Scratch.Easing.easeOutCubic(
                                                   t);

  Real func1;
  Real func2;

  Real m = 5.7553;
  Real b = -5.7648;

  Real aa = -0.5044;
  Real bb = 2.1392;
  Real cc = -0.6463;

  Real dy;
equation

  func1 = m*(time-2)+b;
  func2 = aa*time^2 + bb*time + cc;
  dy = der(y);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10),
    Documentation(info="<html>
<p>https://easings.net/</p>
<p><br>https://joshondesign.com/2013/03/01/improvedEasingEquations</p>
</html>"));
end check_easeInCubicfefae;
