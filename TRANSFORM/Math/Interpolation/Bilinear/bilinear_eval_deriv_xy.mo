within TRANSFORM.Math.Interpolation.Bilinear;
function bilinear_eval_deriv_xy
  "Bilinear (2D) interpolation for table double derivative wrt x and y (same as y and x). Throws error outside of table range."

  extends Interpolation.PartialInterpolation;

external"C" z = bilinear_eval_deriv_xy(
    tablesPath,
    x,
    y) annotation (
    Include="#include \"noname.h\"",
    Library="noname",
    IncludeDirectory="modelica://TRANSFORM/Resources/Include",
    LibraryDirectory="modelica://TRANSFORM/Resources/Library");

end bilinear_eval_deriv_xy;
