within TRANSFORM.Math.Easing.Circular;
model check_easeInCubicfefaeefefaefe

  Real d = 1;

  Real yIn, yOut, yInOut;

  Real b;
  Real c;

  Real dy;
equation

  b = -1*time+1;
  c = time;
  dy = der(yIn);

  yIn = TRANSFORM.Math.Easing.Circular.easeIn(time/d,b,c);
  yOut = b + sqrt(1-(1-time)^2);
  yInOut = TRANSFORM.Math.Easing.Circular.easeInOut(time/d,b,c);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment,
    Documentation(info="<html>
<p>https://easings.net/</p>
<p><br>https://joshondesign.com/2013/03/01/improvedEasingEquations</p>
</html>"));
end check_easeInCubicfefaeefefaefe;
