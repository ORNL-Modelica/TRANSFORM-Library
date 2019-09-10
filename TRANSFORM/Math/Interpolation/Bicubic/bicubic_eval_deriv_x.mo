within TRANSFORM.Math.Interpolation.Bicubic;
function bicubic_eval_deriv_x
  "Bicubic (2D) interpolation for table derivative wrt x. Throws error outside of table range."
  extends Interpolation.PartialInterpolation;
external"C" z = bicubic_eval_deriv_x(
    tablesPath,
    x,
    y) annotation (
    Include="#include \"noname.h\"",
    Library={"noname","gsl"},
    IncludeDirectory="modelica://TRANSFORM/Resources/Include",
    LibraryDirectory="modelica://TRANSFORM/Resources/Library");

annotation (derivative(zeroDerivative=x)=bicubic_eval_deriv_xy,derivative(zeroDerivative=y)=bicubic_eval_deriv_xx);
end bicubic_eval_deriv_x;
