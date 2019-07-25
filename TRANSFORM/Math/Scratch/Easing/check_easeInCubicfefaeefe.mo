within TRANSFORM.Math.Scratch.Easing;
model check_easeInCubicfefaeefe

  Real d = 1;

  Real yIn, yOut, yInOut;

  Real b;
  Real c;

  Real dy;
equation

  b = 0.25;//-1*time+1;
  c = 0.75;//time;
  dy = der(yIn);

  yIn = TRANSFORM.Math.Scratch.Easing.Circular.easeIn(
    time/d,
    b,
    c);
  yOut = TRANSFORM.Math.Scratch.Easing.Circular.easeOut(
    time/d,
    b,
    c);
  yInOut = TRANSFORM.Math.Scratch.Easing.Circular.easeInOut(
    time/d,
    b,
    c);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment,
    Documentation(info="<html>
<p>https://easings.net/</p>
<p><br>https://joshondesign.com/2013/03/01/improvedEasingEquations</p>
</html>"));
end check_easeInCubicfefaeefe;
