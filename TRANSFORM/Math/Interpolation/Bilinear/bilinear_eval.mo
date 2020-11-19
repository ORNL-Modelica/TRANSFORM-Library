within TRANSFORM.Math.Interpolation.Bilinear;
function bilinear_eval
  "Bilinear (2D) interpolation. Throws error outside of table range."
  extends Interpolation.PartialInterpolation;
external"C" z = bilinear_eval(
      tablesPath,
      x,
      y) annotation (
    Include="#include \"noname.h\"",
    Library={"noname","gsl"},
    IncludeDirectory="modelica://TRANSFORM/Resources/Include",
    LibraryDirectory="modelica://TRANSFORM/Resources/Library");

annotation (derivative(zeroDerivative=x)=bilinear_eval_deriv_y,derivative(zeroDerivative=y)=bilinear_eval_deriv_x,derivative(order=2)=bilinear_eval_deriv_xy_alt);
end bilinear_eval;
