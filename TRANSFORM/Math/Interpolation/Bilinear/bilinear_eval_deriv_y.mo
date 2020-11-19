within TRANSFORM.Math.Interpolation.Bilinear;
function bilinear_eval_deriv_y
  "Bilinear (2D) interpolation for table derivative wrt y. Throws error outside of table range."
  extends Interpolation.PartialInterpolation;
external"C" z = bilinear_eval_deriv_y(
    tablesPath,
    x,
    y) annotation (
    Include="#include \"noname.h\"",
    Library={"noname","gsl"},
    IncludeDirectory="modelica://TRANSFORM/Resources/Include",
    LibraryDirectory="modelica://TRANSFORM/Resources/Library");

annotation (derivative(zeroDerivative=y)=bilinear_eval_deriv_xy,derivative(zeroDerivative=x)=bilinear_eval_deriv_yy);
end bilinear_eval_deriv_y;
