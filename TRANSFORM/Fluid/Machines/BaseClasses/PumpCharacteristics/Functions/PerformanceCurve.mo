within TRANSFORM.Fluid.Machines.BaseClasses.PumpCharacteristics.Functions;
function PerformanceCurve
  input Real x "Value of interest";
  input Real x_curve[:];
  input Real y_curve[size(x_curve, 1)];
  input Real r_N(unit="1") "Relative revolution, r_N=N/N_nominal";
  input Real delta=0.05
    "Small value for switching implementation around zero rpm";
  output Real y "Output at x";
protected
  Integer n=size(x_curve, 1) "Dimension of data vector";
  Real r_R(unit="1") "Relative revolution, bounded below by delta";
  Real ratio "Ratio of x/r_N";
  Integer i "Integer to select data interval";
  Real d[size(x_curve, 1)]=TRANSFORM.Math.splineDerivatives(
      x=x_curve,
      y=y_curve,
      ensureMonotonicity=TRANSFORM.Math.isMonotonic(x=y_curve, strict=false));
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
annotation(smoothOrder=1);
end PerformanceCurve;
