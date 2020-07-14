within TRANSFORM.Blocks.Sources;
model dfaefae
  parameter Real height=1 "Height of ramps" annotation (Dialog(groupImage="modelica://Modelica/Resources/Images/Blocks/Sources/Ramp.png"));
  parameter Modelica.SIunits.Time duration(
    min=0.0,
    start=2)=2 "Duration of ramp (= 0.0 gives a Step)";
  extends Modelica.Blocks.Interfaces.SignalSource(startTime=0);

  parameter Real curvature(min=0.0,max=1.0)=0.5 "Fraction of maximum possible corner curvature from 0 to 1";

  parameter Boolean use_shift = true "=true to have ramp slope = height/duration (i.e., shifts ramp to before startTime)";

protected
  final parameter Real xi(fixed=false, start=0.5*radius);
  final parameter Real m(fixed=false, start=height/duration);

  final parameter Real b(fixed=false, start=0);
  final parameter Real radius(fixed=false);

  final parameter Real s(fixed=false,start=-0.25*radius);

initial equation

  // This bounding was determined by setting the circle equation y(x=d/2)=h/2 and solving for r for h<=d. h>d was found by inspection
  if height > duration then
    radius = curvature*0.5*duration;
  else
    radius = curvature*0.25*(duration^2/height + height);
  end if;

  if radius < Modelica.Constants.eps then
    m = height/duration;
    xi = 0;
    b = 0;
    s = 0;
  elseif use_shift then
    b = 0;
    m = height/duration;

    // BC 1 | dy1/dx(x=xi) = dy2/dx(x=xi)
    m = (xi-s)/sqrt(radius^2 - (xi-s)^2);

    // BC 2 | y1(x=xi) = y2(x=xi)
    m*xi + b = -sqrt(radius^2 - (xi-s)^2) + radius;

  else
    s = 0;

    // BC 1 | dy1/dx(x=xi) = dy2/dx(x=xi)
    m = xi/sqrt(radius^2 - xi^2);

    // BC 2 | y1(x=xi) = y2(x=xi)
    m*xi + b = -sqrt(radius^2 - xi^2) + radius;

    // BC 3 | y1(x=duration/2) = height/2
    0.5*height = m*0.5*duration + b;
  end if;

equation

  if radius < Modelica.Constants.eps then
    // Identical to Modelica.Blocks.Sources.Ramp
    y = offset + (if time < startTime then 0 else if time < (startTime +
      duration) then (time - startTime)*height/duration else height);

  else
    y = offset +
    (if time <= startTime+s then 0
  elseif time <= startTime + xi then -sqrt(radius^2 - (time - startTime - s)^2) + radius
  elseif time <= startTime + duration - xi then m*(time - startTime) + b
  elseif time <= startTime - s + duration then sqrt(radius^2 - (time - startTime + s - duration)^2) + (height - radius)
  else height);
  end if;
  annotation (experiment(StopTime=3, __Dymola_Algorithm="Dassl"));
end dfaefae;
