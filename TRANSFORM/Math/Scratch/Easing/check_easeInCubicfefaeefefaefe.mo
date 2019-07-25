within TRANSFORM.Math.Scratch.Easing;
model check_easeInCubicfefaeefefaefe

  Real pos;
  Real neg;
  Real dy;
  Real y;

initial equation
  y = neg;
equation

  pos = -1*time + 2;
  neg = time + 1;

  der(y) = dy;

  dy = TRANSFORM.Math.spliceTanh(
    der(pos),
    der(neg),
    time - 0.5,
    0.1);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment,
    Documentation(info="<html>
<p>https://easings.net/</p>
<p><br>https://joshondesign.com/2013/03/01/improvedEasingEquations</p>
</html>"));
end check_easeInCubicfefaeefefaefe;
