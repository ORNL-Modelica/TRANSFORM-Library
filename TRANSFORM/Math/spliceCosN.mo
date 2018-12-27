within TRANSFORM.Math;
function spliceCosN "Smoothing algorithm using the cos^N function"

  extends Modelica.Icons.Function;
  input Real pos "Returned value for >x+deltax/2";
  input Real neg "Returned value for <x-deltax/2";
  input Real x "Value of interest (i.e. x - x_t)";
  input Real deltax=1 "Transition width";
  input Integer n=2 "(n-1)th order continuous";
  output Real y;

protected
  Real t;
  Real t_lim;
  Real phi=x/deltax*Modelica.Constants.pi;
  Real a;
  Real b;

algorithm

  if n == 1 then
    a := -0.5;
    b := 0.5;
    t := a*sin(phi) + b;
  elseif n == 2 then
    a := -2/Modelica.Constants.pi;
    b := 0.5;
    t := a*(0.5*cos(phi)*sin(phi) + 0.5*phi) + b;
  elseif n == 3 then
    a := -0.75;
    b := 0.5;
    t := a*(1/3*cos(phi)^2*sin(phi) + 2/3*sin(phi)) + b;
  elseif n == 4 then
    a := -8/3*Modelica.Constants.pi;
    b := 0.5;
    t := a*(0.25*cos(phi)^3*sin(phi) + 3/8*cos(phi)*sin(phi) + 3/8*phi) + b;
  else
    assert(false, "Provided n value is not supported");
  end if;

  t_lim := max(min(t, 1), 0);

  y := (1 - t_lim)*pos + t_lim*neg;

  annotation (smoothOrder=4);
end spliceCosN;
