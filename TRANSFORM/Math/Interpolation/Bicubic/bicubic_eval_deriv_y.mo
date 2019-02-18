within TRANSFORM.Math.Interpolation.Bicubic;
function bicubic_eval_deriv_y
  "Bicubic (2D) interpolation for table derivative wrt y. Throws error outside of table range."
  extends Interpolation.PartialInterpolation;
external"C" z = bicubic_eval_deriv_y(
    tablesPath,
    x,
    y) annotation (
    Include="#include \"noname.h\"",
    Library="noname",
    IncludeDirectory="modelica://TRANSFORM/Resources/Include",
    LibraryDirectory="modelica://TRANSFORM/Resources/Library");

annotation (derivative(zeroDerivative=y)=bicubic_eval_deriv_xy,derivative(zeroDerivative=x)=bicubic_eval_deriv_yy);
end bicubic_eval_deriv_y;
