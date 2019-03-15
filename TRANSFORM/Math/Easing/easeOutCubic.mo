within TRANSFORM.Math.Easing;
function easeOutCubic

  extends TRANSFORM.Icons.Function;

  input Real t "Normalized scale: t = x/d";
  output Real val;

algorithm

  val :=1-easeInCubic(1-t);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end easeOutCubic;
