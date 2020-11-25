within TRANSFORM.Math.Easing.Examples;
model Quad
  extends TRANSFORM.Icons.Example;

  parameter Real pos = 2;
  parameter Real neg = -3;
  parameter Real x0 = 5;
  parameter Real deltax = 3;

  Real dy;
  Real dy_easeIn;
  Real dy_easeOut;
  Real dy_easeInOut;
  Real y;
  Real y_easeIn;
  Real y_easeOut;
  Real y_easeInOut;

equation

  y = TRANSFORM.Math.spliceTanh(
    pos=pos,
    neg=neg,
    x=time - x0,
    deltax=deltax);
  dy = der(y);

  y_easeIn = TRANSFORM.Math.Easing.Cubic.easeIn(
    pos=pos,
    neg=neg,
    x=time - x0,
    deltax=deltax);
  dy_easeIn = der(y_easeIn);

  y_easeOut = TRANSFORM.Math.Easing.Quad.easeOut(
    pos=pos,
    neg=neg,
    x=time - x0,
    deltax=deltax);
  dy_easeOut = der(y_easeOut);

  y_easeInOut = TRANSFORM.Math.Easing.Quad.easeInOut(
    pos=pos,
    neg=neg,
    x=time - x0,
    deltax=deltax);
  dy_easeInOut = der(y_easeInOut);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10, __Dymola_Algorithm="Dassl"));
end Quad;
