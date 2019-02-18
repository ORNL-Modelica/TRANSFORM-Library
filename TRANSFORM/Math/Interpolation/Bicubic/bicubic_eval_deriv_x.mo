within TRANSFORM.Math.Interpolation.Bicubic;
function bicubic_eval_deriv_x
  "Bicubic (2D) interpolation for table derivative wrt x. Throws error outside of table range."
  extends Interpolation.PartialInterpolation;
external"C" z = bicubic_eval_deriv_x(
    tablesPath,
    x,
    y) annotation (
    Include="#include \"noname.h\"",
    Library="noname",
    IncludeDirectory="modelica://TRANSFORM/Resources/Include",
    LibraryDirectory="modelica://TRANSFORM/Resources/Library");
end bicubic_eval_deriv_x;
