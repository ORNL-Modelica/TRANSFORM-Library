within TRANSFORM.Math.Scratch.Easing.Models;
partial model EaseInSine
  Real scaledX;
  Real y;
equation
  y = 1-cos((scaledX+1)*Modelica.Constants.pi/4);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end EaseInSine;
