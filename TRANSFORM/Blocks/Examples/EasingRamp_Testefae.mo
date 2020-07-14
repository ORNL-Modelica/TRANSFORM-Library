within TRANSFORM.Blocks.Examples;
model EasingRamp_Testefae
  extends TRANSFORM.Icons.Example;

  //   Utilities.ErrorAnalysis.UnitTests unitTests(x={easingRamp.y})
  //     annotation (Placement(transformation(extent={{80,80},{100,100}})));
  //   Sources.EasingRamp easingRamp(
  //     duration=0.5,
  //     offset=1,
  //     startTime=0.25,
  //     deltax=0.1)
  //     annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  parameter Real height=1 "Height of ramps" annotation (Dialog(groupImage="modelica://Modelica/Resources/Images/Blocks/Sources/Ramp.png"));
  parameter Modelica.SIunits.Time duration(
    min=0.0,
    start=2) = 2 "Duration of ramp (= 0.0 gives a Step)";
  extends Modelica.Blocks.Interfaces.SignalSource(startTime=0.2, offset=2);

  parameter Real curvature=0.5;
  //Real yi(start=0.5*radius);

  Real xi(start=0.5*radius);
  Real m;

  Real b;
  Real dy;
  parameter Real radius=if height > duration then curvature*0.5*duration else
      curvature*0.25*(duration^2/height + height);

  // initial equation
  // if height>duration then
  //   assert(radius<=0.5*duration, "For a height greater than duration, maximum radius is 0.5*duration");
  // else
  //   assert(radius<= 0.25*(duration^2/height + height), "For a height less than duration, maximm radius is 0.25*(duration^2/height + height)");
  // end if;

equation
  //assert(curvature >= Modelica.Constants.eps, "curvature must be greater than 0");
  //   // Limit set by the the point y(x=d/2)=h/2
  //   if height>duration then
  //     radius = curvature*0.5*duration;
  //   else
  //     radius = curvature*0.25*(duration^2/height + height);
  //   end if;

  // y1 = m*time+b;
  // y2plus = sqrt(radius^2-time^2)+radius;
  // y2neg = -sqrt(radius^2-time^2)+radius;

//   if radius < Modelica.Constants.eps then
//     m = height/duration;
//     xi = 0;
//     b=0;
//     // Identical to Modelica.Blocks.Sources.Ramp
//     y = offset + (if time < startTime then 0 else if time < (startTime +
//       duration) then (time - startTime)*height/duration else height);
//   else

    // BC 1 | dy1/dx(x=xi) = dy2/dx(x=xi)
    m = xi/sqrt(radius^2 - xi^2);

    // BC 2 | y1(x=xi) = y2(x=xi)
    m*xi + b = -sqrt(radius^2 - xi^2) + radius;

    // BC 3 | y1(x=duration/2) = height/2
    0.5*height = m*0.5*duration + b;

    y = offset + (if time <= startTime then 0 elseif time <= startTime + xi
       then -sqrt(radius^2 - (time - startTime)^2) + radius elseif time <=
      startTime + duration - xi then m*(time - startTime) + b elseif time <=
      startTime + duration then sqrt(radius^2 - (time - startTime - duration)^2)
       + (height - radius) else height);
//   end if;

  dy = der(y);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=5, __Dymola_Algorithm="Dassl"));
end EasingRamp_Testefae;
