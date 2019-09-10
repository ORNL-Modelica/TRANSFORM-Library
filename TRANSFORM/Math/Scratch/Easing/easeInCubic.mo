within TRANSFORM.Math.Scratch.Easing;
function easeInCubic

  extends TRANSFORM.Icons.Function;

  input Real t "Normalized scale: t = x/d";
  output Real val;

algorithm

  val :=t^3;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end easeInCubic;
