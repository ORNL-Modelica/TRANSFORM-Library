within TRANSFORM.Math;
function regFun3 "Co-monotonic and C1 smooth regularization function"
  extends Modelica.Icons.Function;

  input Real x "Abscissa value";
  input Real x0 "Lower abscissa value";
  input Real x1 "Upper abscissa value";
  input Real y0 "Ordinate value at lower abscissa value";
  input Real y1 "Ordinate value at upper abscissa value";
  input Real y0d "Derivative at lower abscissa value";
  input Real y1d "Derivative at upper abscissa value";

  output Real y "Ordinate value";
  output Real c
    "Slope of linear section between two cubic polynomials or dummy linear section slope if single cubic is used";

protected
  Real h0 "Width of interval i=0";
  Real Delta0 "Slope of secant on interval i=0";
  Real xstar "Inflection point of cubic polynomial S0";
  Real mu "Distance of inflection point and left limit x0";
  Real eta "Distance of right limit x1 and inflection point";
  Real omega "Slope of cubic polynomial S0 at inflection point";
  Real rho "Weighting factor of eta and eta_tilde, mu and mu_tilde";
  Real theta0 "Slope metric";
  Real mu_tilde "Distance of start of linear section and left limit x0";
  Real eta_tilde "Distance of right limit x1 and end of linear section";
  Real xi1 "Start of linear section";
  Real xi2 "End of linear section";
  Real a1 "Leading coefficient of cubic on the left";
  Real a2 "Leading coefficient of cubic on the right";
  Real const12 "Integration constant of left cubic, linear section";
  Real const3 "Integration constant of right cubic";
  Real aux01;
  Real aux02;
  Boolean useSingleCubicPolynomial=false
    "Indicate to override further logic and use single cubic";
algorithm
  // Check arguments: Data point position
  assert(x0 < x1, "regFun3(): Data points not sorted appropriately (x0 = " +
    String(x0) + " > x1 = " + String(x1) + "). Please flip arguments.");
  // Check arguments: Data point derivatives
  if y0d*y1d >= 0 then
    // Derivatives at data points allow co-monotone interpolation, nothing to do
  else
    // Strictly speaking, derivatives at data points do not allow co-monotone interpolation, however, they may be numerically zero so assert this
    assert(abs(y0d)<Modelica.Constants.eps or abs(y1d)<Modelica.Constants.eps, "regFun3(): Derivatives at data points do not allow co-monotone interpolation, as both are non-zero, of opposite sign and have an absolute value larger than machine eps (y0d = " +
    String(y0d) + ", y1d = " + String(y1d) + "). Please correct arguments.");
  end if;

  h0 := x1 - x0;
  Delta0 := (y1 - y0)/h0;

  if abs(Delta0) <= 0 then
    // Points (x0,y0) and (x1,y1) on horizontal line
    // Degenerate case as we cannot fulfill the C1 goal an comonotone behaviour at the same time
    y := y0 + Delta0*(x-x0);     // y == y0 == y1 with additional term to assist automatic differentiation
    c := 0;
  elseif abs(y1d + y0d - 2*Delta0) < 100*Modelica.Constants.eps then
    // Inflection point at +/- infinity, thus S0 is co-monotone and can be returned directly
    y := y0 + (x-x0)*(y0d + (x-x0)/h0*( (-2*y0d-y1d+3*Delta0) + (x-x0)*(y0d+y1d-2*Delta0)/h0));
    // Provide a "dummy linear section slope" as the slope of the cubic at x:=(x0+x1)/2
    aux01 := (x0 + x1)/2;
    c := 3*(y0d + y1d - 2*Delta0)*(aux01 - x0)^2/h0^2 + 2*(-2*y0d - y1d + 3*Delta0)*(aux01 - x0)/h0
       + y0d;
  else
    // Points (x0,y0) and (x1,y1) not on horizontal line and inflection point of S0 not at +/- infinity
    // Do actual interpolation
    xstar := 1/3*(-3*x0*y0d - 3*x0*y1d + 6*x0*Delta0 - 2*h0*y0d - h0*y1d + 3*h0*
      Delta0)/(-y0d - y1d + 2*Delta0);
    mu := xstar - x0;
    eta := x1 - xstar;
    omega := 3*(y0d + y1d - 2*Delta0)*(xstar - x0)^2/h0^2 + 2*(-2*y0d - y1d + 3*
      Delta0)*(xstar - x0)/h0 + y0d;

    aux01 := 0.25*sign(Delta0)*min(abs(omega), abs(Delta0))
      "Slope c if not using plain cubic S0";
    if abs(y0d - y1d) <= 100*Modelica.Constants.eps then
      // y0 == y1 (value and sign equal) -> resolve indefinite 0/0
      aux02 := y0d;
      if y1 > y0 + y0d*(x1 - x0) then
        // If y1 is above the linear extension through (x0/y0)
        // with slope y0d (when slopes are identical)
        //  -> then always used single cubic polynomial
        useSingleCubicPolynomial := true;
      end if;
    elseif abs(y1d + y0d - 2*Delta0) < 100*Modelica.Constants.eps then
      // (y1d+y0d-2*Delta0) approximately 0 -> avoid division by 0
      aux02 := (6*Delta0*(y1d + y0d - 3/2*Delta0) - y1d*y0d - y1d^2 - y0d^2)*(
        if (y1d + y0d - 2*Delta0) >= 0 then 1 else -1)*Modelica.Constants.inf;
    else
      // Okay, no guarding necessary
      aux02 := (6*Delta0*(y1d + y0d - 3/2*Delta0) - y1d*y0d - y1d^2 - y0d^2)/(3*
        (y1d + y0d - 2*Delta0));
    end if;

    //aux02 := -1/3*(y0d^2+y0d*y1d-6*y0d*Delta0+y1d^2-6*y1d*Delta0+9*Delta0^2)/(y0d+y1d-2*Delta0);
    //aux02 := -1/3*(6*y1d*y0*x1+y0d*y1d*x1^2-6*y0d*x0*y0+y0d^2*x0^2+y0d^2*x1^2+y1d^2*x1^2+y1d^2*x0^2-2*y0d*x0*y1d*x1-2*x0*y0d^2*x1+y0d*y1d*x0^2+6*y0d*x0*y1-6*y0d*y1*x1+6*y0d*y0*x1-2*x0*y1d^2*x1-6*y1d*y1*x1+6*y1d*x0*y1-6*y1d*x0*y0-18*y1*y0+9*y1^2+9*y0^2)/(y0d*x1^2-2*x0*y0d*x1+y1d*x1^2-2*x0*y1d*x1-2*y1*x1+2*y0*x1+y0d*x0^2+y1d*x0^2+2*x0*y1-2*x0*y0);

    // Test criteria (also used to avoid saddle points that lead to integrator contraction):
    //
    //  1. Cubic is not monotonic (from Gasparo Morandi)
    //       ((mu > 0) and (eta < h0) and (Delta0*omega <= 0))
    //
    //  2. Cubic may be monotonic but the linear section slope c is either too close
    //     to zero or the end point of the linear section is left of the start point
    //     Note however, that the suggested slope has to have the same sign as Delta0.
    //       (abs(aux01)<abs(aux02) and aux02*Delta0>=0)
    //
    //  3. Cubic may be monotonic but the resulting slope in the linear section
    //     is too close to zero (less than 1/10 of Delta0).
    //       (c < Delta0 / 10)
    //
    if (((mu > 0) and (eta < h0) and (Delta0*omega <= 0)) or (abs(aux01) < abs(
        aux02) and aux02*Delta0 >= 0) or (abs(aux01) < abs(0.1*Delta0))) and
        not useSingleCubicPolynomial then
      // NOT monotonic using plain cubic S0, use piecewise function S0 tilde instead
      c := aux01;
      // Avoid saddle points that are co-monotonic but lead to integrator contraction
      if abs(c) < abs(aux02) and aux02*Delta0 >= 0 then
        c := aux02;
      end if;
      if abs(c) < abs(0.1*Delta0) then
        c := 0.1*Delta0;
      end if;
      theta0 := (y0d*mu + y1d*eta)/h0;
      if abs(theta0 - c) < 1e-6 then
        // Slightly reduce c in order to avoid ill-posed problem
        c := (1 - 1e-6)*theta0;
      end if;
      rho := 3*(Delta0 - c)/(theta0 - c);
      mu_tilde := rho*mu;
      eta_tilde := rho*eta;
      xi1 := x0 + mu_tilde;
      xi2 := x1 - eta_tilde;
      a1 := (y0d - c)/max(mu_tilde^2, 100*Modelica.Constants.eps);
      a2 := (y1d - c)/max(eta_tilde^2, 100*Modelica.Constants.eps);
      const12 := y0 - a1/3*(x0 - xi1)^3 - c*x0;
      const3 := y1 - a2/3*(x1 - xi2)^3 - c*x1;
      // Do actual interpolation
      if (x < xi1) then
        y := a1/3*(x - xi1)^3 + c*x + const12;
      elseif (x < xi2) then
        y := c*x + const12;
      else
        y := a2/3*(x - xi2)^3 + c*x + const3;
      end if;
    else
      // Cubic S0 is monotonic, use it as is
      y := y0 + (x-x0)*(y0d + (x-x0)/h0*( (-2*y0d-y1d+3*Delta0) + (x-x0)*(y0d+y1d-2*Delta0)/h0));
      // Provide a "dummy linear section slope" as the slope of the cubic at x:=(x0+x1)/2
      aux01 := (x0 + x1)/2;
      c := 3*(y0d + y1d - 2*Delta0)*(aux01 - x0)^2/h0^2 + 2*(-2*y0d - y1d + 3*Delta0)*(aux01 - x0)/h0
         + y0d;
    end if;
  end if;

  annotation (smoothOrder=1, Documentation(revisions="<html>
<ul>
<li><i>May 2008</i> by <a href=\"mailto:Michael.Sielemann@dlr.de\">Michael Sielemann</a>:<br/>Designed and implemented.</li>
<li><i>February 2011</i> by <a href=\"mailto:Michael.Sielemann@dlr.de\">Michael Sielemann</a>:<br/>If the inflection point of the cubic S0 was at +/- infinity, the test criteria of <i>[Gasparo and Morandi, 1991]</i> result in division by zero. This case is handled properly now.</li>
<li><i>March 2013</i> by <a href=\"mailto:Michael.Sielemann@dlr.de\">Michael Sielemann</a>:<br/>If the arguments prescribed a degenerate case with points <code>(x0,y0)</code> and <code>(x1,y1)</code> on horizontal line, then return value <code>c</code> was undefined. This was corrected. Furthermore, an additional term was included for the computation of <code>y</code> in this case to assist automatic differentiation.</li>
</ul>
</html>", info="<html>
<p>
Approximates a function in a region between <code>x0</code> and <code>x1</code>
such that
</p>
<ul>
<li> The overall function is continuous with a
     continuous first derivative everywhere.</li>
<li> The function is co-monotone with the given
     data points.</li>
</ul>
<p>
In this region, a continuation is constructed from the given points
<code>(x0, y0)</code>, <code>(x1, y1)</code> and the respective
derivatives. For this purpose, a single polynomial of third order or two
cubic polynomials with a linear section in between are used <i>[Gasparo
and Morandi, 1991]</i>. This algorithm was extended with two additional
conditions to avoid saddle points with zero/infinite derivative that lead to
integrator step size reduction to zero.
</p>
<p>
This function was developed for pressure loss correlations properly
addressing the static head on top of the established requirements
for monotonicity and smoothness. In this case, the present function
allows to implement the exact solution in the limit of
<code>x1-x0 -> 0</code> or <code>y1-y0 -> 0</code>.
</p>
<p>
Typical screenshots for two different configurations
are shown below. The first one illustrates five different settings of <code>xi</code> and <code>yid</code>:
</p>
<p>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/regFun3_a.png\"
      alt=\"regFun3_a.png\">
</p>
<p>
The second graph shows the continuous derivative of this regularization function:
</p>
<p>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/regFun3_b.png\"
     alt=\"regFun3_a.png\">
</p>

<p>
<b>Literature</b>
</p>

<dl>
<dt> Gasparo M. G. and Morandi R. (1991):</dt>
<dd> <b>Piecewise cubic monotone interpolation with assigned slopes</b>.
     Computing, Vol. 46, Issue 4, December 1991, pp. 355 - 365.</dd>
</dl>
</html>"));
end regFun3;
