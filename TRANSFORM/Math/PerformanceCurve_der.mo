within TRANSFORM.Math;
function PerformanceCurve_der
  "Time derivative of TRANSFORM.Math.PerformanceCurve (curves and d[] are parameters)"
  extends TRANSFORM.Icons.Function;
  input Real x;
  input Real x_curve[:];
  input Real y_curve[size(x_curve, 1)];
  input Real d[size(x_curve, 1)];
  input Real r_N(unit="1");
  input Real delta;
  input Real x_der;
  input Real r_N_der;
  output Real y_der;
protected
  Integer n=size(x_curve, 1);
  Real r_R;
  Real dr_R_dr_N;
  Real r_R_der;
  Real ratio;
  Real ratio_der;
  Integer i;
  Real h;
  Real t;
  Real dy_dratio;
algorithm
  // r_R(r_N): piecewise smoothing of relative speed near zero
  if r_N > delta then
    r_R := r_N;
    dr_R_dr_N := 1;
  elseif r_N < 0 then
    r_R := 0.5*delta;
    dr_R_dr_N := 0;
  else
    // Specialised derivative of the cubic Hermite blend used by PerformanceCurve:
    //   cubicHermiteSpline(r_N, 0, delta, 0.5*delta, delta, 0, 1)
    //   == 0.5*delta*(1 + (r_N/delta)^2)
    r_R := 0.5*delta*(1 + (r_N/delta)^2);
    dr_R_dr_N := r_N/delta;
  end if;
  r_R_der := dr_R_dr_N*r_N_der;

  if n == 1 then
    y_der := 0;
  else
    ratio := x/r_R;
    ratio_der := x_der/r_R - x*r_R_der/(r_R*r_R);

    // Interval selection mirrors PerformanceCurve exactly
    i := 1;
    for j in 1:n - 1 loop
      if ratio > x_curve[j] then
        i := j;
      end if;
    end for;

    // dy/dratio for cubicHermiteSplineLinearExtrapolation
    if ratio > x_curve[i] and ratio < x_curve[i + 1] then
      h := x_curve[i + 1] - x_curve[i];
      t := (ratio - x_curve[i])/h;
      // Hermite basis derivatives wrt t:
      //   h00'(t) = 6t^2 - 6t
      //   h10'(t) = 3t^2 - 4t + 1
      //   h01'(t) = -6t^2 + 6t
      //   h11'(t) = 3t^2 - 2t
      // dy/dratio = (1/h) * dy/dt
      dy_dratio := (y_curve[i]*(6*t*t - 6*t)
                  + h*d[i]*(3*t*t - 4*t + 1)
                  + y_curve[i + 1]*(-6*t*t + 6*t)
                  + h*d[i + 1]*(3*t*t - 2*t))/h;
    elseif ratio <= x_curve[i] then
      dy_dratio := d[i];
    else
      dy_dratio := d[i + 1];
    end if;

    y_der := dy_dratio*ratio_der;
  end if;
  annotation (Documentation(info="<html>
<p>Analytic time derivative of <a href=\"modelica://TRANSFORM.Math.PerformanceCurve\">TRANSFORM.Math.PerformanceCurve</a>.
The curve arrays <code>x_curve</code>, <code>y_curve</code>, the precomputed spline-tangent array <code>d</code>,
and the smoothing width <code>delta</code> are treated as parameters (<code>zeroDerivative</code> in the parent annotation),
so only the time-varying inputs <code>x</code> and <code>r_N</code> contribute.</p>
</html>"));
end PerformanceCurve_der;
