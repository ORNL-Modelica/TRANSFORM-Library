within TRANSFORM.Math;
function smoothing_cosN "Smoothing using a*cos(x)^n base function"

  input Real x "Value of interest (i.e. x - x_t)";
  input Real deltax "Transition width";
  input Integer n=2 "(n-1)th order continuous";
  output Real y "Sigmoid result";

protected
  Real phi=x/deltax*Modelica.Constants.pi;
  Real a;
  Real b;

algorithm

  if n == 1 then
    a := -0.5;
    b := 0.5;
    y := a*sin(phi) + b;
  elseif n == 2 then
    a := -2/Modelica.Constants.pi;
    b := 0.5;
    y := a*(0.5*cos(phi)*sin(phi) + 0.5*phi) + b;
  elseif n == 3 then
    a := -0.75;
    b := 0.5;
    y := a*(1/3*cos(phi)^2*sin(phi) + 2/3*sin(phi)) + b;
  elseif n == 4 then
    a := -8/3*Modelica.Constants.pi;
    b := 0.5;
    y := a*(0.25*cos(phi)^3*sin(phi) + 3/8*cos(phi)*sin(phi) + 3/8*phi) + b;
  else
    assert(false, "Provided n value is not supported");
  end if;

  annotation (smoothOrder=n - 1, Documentation(info="<html>
<p>Smoothing function as presented in C. RICHTER, &ldquo;Proposal of New Object-Oriented Equation-Based Model Libraries for Thermodynamic Systems,&rdquo; Technical University Carolo-Wilhelmina in Braunschweig (2008). </p>
<p><br>The general solution is a hypergeometric function (http://mathworld.wolfram.com/HypergeometricFunction.html): 2f1. This function exists in scipy and GNU GSL.</p>
</html>"));
end smoothing_cosN;
