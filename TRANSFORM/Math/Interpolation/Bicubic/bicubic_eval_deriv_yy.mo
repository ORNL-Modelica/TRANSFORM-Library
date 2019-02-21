within TRANSFORM.Math.Interpolation.Bicubic;
function bicubic_eval_deriv_yy
  "Bicubic (2D) interpolation for table double derivative wrt y. Throws error outside of table range."
  extends Interpolation.PartialInterpolation;
external"C" z = bicubic_eval_deriv_yy(
    tablesPath,
    x,
    y) annotation (
    Include="#include \"noname.h\"",
    Library="noname",
    IncludeDirectory="modelica://TRANSFORM/Resources/Include",
    LibraryDirectory="modelica://TRANSFORM/Resources/Library");
end bicubic_eval_deriv_yy;
