within TRANSFORM.Math.Interpolation.Bilinear;
function bilinear_eval_deriv_yy
  "Bilinear (2D) interpolation for table double derivative wrt y. Throws error outside of table range."

  extends Interpolation.PartialInterpolation;

external"C" z = bilinear_eval_deriv_yy(
    tablesPath,
    x,
    y) annotation (
    Include="#include \"noname.h\"",
    Library="noname",
    IncludeDirectory="modelica://TRANSFORM/Resources/Include",
    LibraryDirectory="modelica://TRANSFORM/Resources/Library");

end bilinear_eval_deriv_yy;
