within TRANSFORM.Math.Interpolation.Bicubic;
function bicubic_eval_extrap
  "Bicubic (2D) interpolation. Extrapolates outside of table range."
  extends Interpolation.PartialInterpolation;
external"C" z = bicubic_eval_extrap(
      tablesPath,
      x,
      y) annotation (
    Include="#include \"noname.h\"",
    Library="noname",
    IncludeDirectory="modelica://TRANSFORM/Resources/Include",
    LibraryDirectory="modelica://TRANSFORM/Resources/Library");

annotation (derivative(zeroDerivative=x)=bicubic_eval_deriv_y,derivative(zeroDerivative=y)=bicubic_eval_deriv_x,derivative(order=2)=bicubic_eval_deriv_xy_alt);
end bicubic_eval_extrap;
