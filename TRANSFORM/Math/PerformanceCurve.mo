within TRANSFORM.Math;
function PerformanceCurve
  input Real x "Value of interest";
  input Real x_curve[:] "Abcissa";
  input Real y_curve[size(x_curve, 1)] "Ordinate";
  input Real d[size(x_curve, 1)]=TRANSFORM.Math.splineDerivatives(
      x=x_curve,
      y=y_curve,
      ensureMonotonicity=TRANSFORM.Math.isMonotonic(x=y_curve, strict=false))
    "Derivatives at the support points (precomputed; default keeps backward compatibility)";
  input Real r_N(unit="1") "Relative revolution, r_N=N/N_nominal";
  input Real delta=0.05
    "Small value for switching implementation around zero rpm";
  output Real y "Output at x";

protected
  Integer n=size(x_curve, 1) "Dimension of data vector";
  Real r_R(unit="1") "Relative revolution, bounded below by delta";
  Real ratio "Ratio of x/r_N";
  Integer i "Integer to select data interval";

algorithm
  // For r_N < delta, we restrict r_N in the term V_flow/r_N.
  // This is done using a cubic spline in a region 0.75*delta < r_N < 1.25*r_N
  // We call this restricted value r_R
  if r_N > delta then
    r_R :=r_N;
  elseif r_N < 0 then
    r_R := 0.5*delta;
  else
    // Restrict r_N using a spline
    r_R :=TRANSFORM.Math.cubicHermiteSpline(
      x=r_N,
      x1=0,
      x2=delta,
      y1=0.5*delta,
      y2=delta,
      y1d=0,
      y2d=1);
  end if;
  if n == 1 then
    y := y_curve[1];
  else
    i := 1;
    // The use of the max function to avoids problems for low speeds
    // and turned off pumps
//     ratio := x/TRANSFORM.Math.smoothMax_splice(
//       x1=r_N,
//       x2=0.1,
//       deltaX=delta);
    ratio := x/r_R;
    for j in 1:n - 1 loop
      if ratio > x_curve[j] then
        i := j;
      end if;
    end for;
    // Extrapolate or interpolate the data
    y := TRANSFORM.Math.cubicHermiteSplineLinearExtrapolation(
      x=ratio,
      x1=x_curve[i],
      x2=x_curve[i + 1],
      y1=y_curve[i],
      y2=y_curve[i + 1],
      y1d=d[i],
      y2d=d[i + 1]);
  end if;
annotation(
  smoothOrder=1,
  derivative(
    zeroDerivative=x_curve,
    zeroDerivative=y_curve,
    zeroDerivative=d,
    zeroDerivative=delta) = PerformanceCurve_der,
  Documentation(info="<html>
<p>Evaluates a pump performance curve <code>y = f(x, r_N)</code> using monotone cubic Hermite
interpolation between the support points <code>(x_curve[i], y_curve[i])</code>, with linear
extrapolation outside the data range and a smooth blending of the relative speed
<code>r_N = N/N_nominal</code> near zero.</p>

<p>The function is used by the pump head, flow, and power characteristic models to apply pump
affinity-law scaling: the abscissa is normalised by the relative-speed factor
(<code>ratio = x/r_R</code>) before the curve lookup, where <code>r_R</code> is <code>r_N</code>
itself for <code>r_N &gt; delta</code> and a cubic Hermite blend down to <code>0.5*delta</code> for
<code>r_N &le; delta</code> (clamped to <code>0.5*delta</code> for negative <code>r_N</code>).
This avoids division-by-zero singularities when the pump is stopped or near stopped.</p>

<h4>Arguments</h4>
<ul>
<li><code>x</code>, <code>r_N</code> — time-varying inputs.</li>
<li><code>x_curve</code>, <code>y_curve</code>, <code>delta</code> — parameters that fix the curve shape.</li>
<li><code>d</code> — spline tangents at the support points. Defaults to
<code>splineDerivatives(x_curve, y_curve, isMonotonic(y_curve, false))</code>; pass it explicitly
(computed once as a <code>final parameter</code> in the calling model) so the symbolic engine
does not re-evaluate it on every call.</li>
</ul>

<h4>Differentiation</h4>
<p><code>smoothOrder = 1</code> declares the result is C&sup1; in <code>x</code> and <code>r_N</code>.
The <code>derivative</code> annotation provides
<a href=\"modelica://TRANSFORM.Math.PerformanceCurve_der\">PerformanceCurve_der</a> as the analytic
time derivative, with <code>x_curve</code>, <code>y_curve</code>, <code>d</code> and
<code>delta</code> declared <code>zeroDerivative</code>. This lets Dymola build analytic
Jacobians for systems containing pump curves &mdash; previously the chain rule descended into
<code>splineDerivatives</code> and failed.</p>
</html>"));
end PerformanceCurve;
