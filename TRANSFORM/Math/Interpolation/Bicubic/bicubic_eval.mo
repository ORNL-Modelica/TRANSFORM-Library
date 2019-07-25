within TRANSFORM.Math.Interpolation.Bicubic;
function bicubic_eval
  "Bicubic (2D) interpolation. Throws error outside of table range."
extends Interpolation.PartialInterpolation;
external"C" z = bicubic_eval(
      tablesPath,
      x,
      y) annotation (
    Include="#include \"noname.h\"",
    Library={"noname","gsl"},
    IncludeDirectory="modelica://TRANSFORM/Resources/Include",
    LibraryDirectory="modelica://TRANSFORM/Resources/Library");

annotation (derivative(zeroDerivative=x)=bicubic_eval_deriv_y,derivative(zeroDerivative=y)=bicubic_eval_deriv_x,derivative(order=2)=bicubic_eval_deriv_xy_alt);
end bicubic_eval;
