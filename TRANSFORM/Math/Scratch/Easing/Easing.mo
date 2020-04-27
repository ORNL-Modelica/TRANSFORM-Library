within TRANSFORM.Math.Scratch.Easing;
model Easing

  replaceable function Easing = TRANSFORM.Math.Scratch.Easing.Sine.easeInOut
    constrainedby TRANSFORM.Math.Scratch.Easing.PartialEasing "Transition function" annotation (
      choicesAllMatching=true);

  parameter Real pos "Returned value for time-dt >= 0";
  parameter Real neg "Returned value for time+dt <= 0";
  parameter SI.Time dt=1
    "Region around transition time with spline interpolation";

  extends Modelica.Blocks.Interfaces.SignalSource;


equation

  y = Easing(
    pos=pos,
    neg=neg,
    x=time - startTime - dt,
    deltax=dt) + offset;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Easing;
