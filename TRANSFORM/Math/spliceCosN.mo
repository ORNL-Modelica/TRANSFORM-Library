within TRANSFORM.Math;
function spliceCosN "Smoothing algorithm using the cos^N function"

  extends Modelica.Icons.Function;
  input Real below "Returned value for <x-deltax/2";
  input Real above "Returned value for >x+deltax/2";
  input Real x "Value of interest (i.e. x - x_t)";
  input Real deltax=1 "Transition width";
  input Integer n=2 "(n-1)th order continuous";
  output Real out;

protected
  Real t;
  Real t_lim;
algorithm
  t :=TRANSFORM.Math.smoothing_cosN(
    x,
    deltax,
    n);
    t_lim :=max(min(t, 1), 0);

  out :=(1 - t_lim)*below + t_lim*above;

  annotation (smoothOrder=n-1);
end spliceCosN;
