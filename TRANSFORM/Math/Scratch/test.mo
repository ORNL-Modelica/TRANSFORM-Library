within TRANSFORM.Math.Scratch;
function test
  extends TRANSFORM.Icons.Function;
  input Real t "Abcissa value";
  input Real r0=1 "Radii of the largest circle";
  input Real ratio=0.5 "Ratio of smallest to smallest circle = r1/r0";
  input Real m = 1;
  input SI.Angle theta(
    min=0,
    max=Modelica.Constants.pi/2) = Modelica.Constants.pi/4;
  input Boolean s_shaped=true "=true if S-shaped else C-shaped";
  output Real z;
  output Real x;
  output Real y;

protected
  Real lambda=sqrt(ratio);
  Real p=m*1/cos(theta)*sqrt(8*sin(theta)/27);

  // Line lengths between points
  Real g=p*r0*sqrt(2*sin(theta)/3);
  Real h=p^2*r0;
  Real k=p*r0*sqrt(2*sin(theta)/3)*lambda;

  // Control points
  Real P0[2];
  Real P1[2];
  Real P2[2];
  Real P3[2];

  // min for m
  // s-shape = 1
  // c-shape = (1+sqrt(1+3*lambda))/3
algorithm

  // Cubic Bezier curve
  //Z := (1 - t^3)*P0 + 3*t*(1 - t)^2*P1 + 3*t^2*(1 - t)*P2 + t^3*P3;

  if s_shaped then
    P0 := {0,0};
    P1 := {g,0};
    P2 := {g + h*cos(theta),h*sin(theta)};
    P3 := {g + h*cos(theta) + k,h*sin(theta)};
  else
    P0 := {0,0};
    P1 := {g,0};
    P2 := {g + h*cos(theta),h*sin(theta)};
    P3 := {g + h*cos(theta) + k*cos(2*theta),h*sin(theta) + k*sin(2*theta)};
  end if;

  x := (1 - t^3)*P0[1] + 3*t*(1 - t)^2*P1[1] + 3*t^2*(1 - t)*P2[1] + t^3*P3[1];
  y := (1 - t^3)*P0[2] + 3*t*(1 - t)^2*P1[2] + 3*t^2*(1 - t)*P2[2] + t^3*P3[2];

  z := sqrt(x^2 + y^2);

  annotation (smoothOrder=4, Documentation(info="<html>
<p>Implementation of the psi or digamma function. See also scipy.special.psi or scipy.special.digamma</p>
<p>Source:</p>
<p> - http://scipp.ucsc.edu/~haber/ph116A/psifun_11.pdf</p>
<p>- NATIONAL INSTITUTE OF STANDARDS AND TECHNOLOGY, <i>NIST handbook of mathematical functions</i>, F. W. J. Olver et al., Eds., Cambridge University Press, Cambridge New York Melbourne (2010). </p>
</html>"));
end test;
