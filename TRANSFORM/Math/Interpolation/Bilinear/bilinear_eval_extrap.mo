within TRANSFORM.Math.Interpolation.Bilinear;
function bilinear_eval_extrap
  "Bilinear (2D) interpolation. Extrapolates outside of table range."

  extends Interpolation.PartialInterpolation;

external"C" z = bilinear_eval_extrap(
      tablesPath,
      x,
      y) annotation (
    Include="#include \"noname.h\"",
    Library="noname",
    IncludeDirectory="modelica://TRANSFORM/Resources/Include",
    LibraryDirectory="modelica://TRANSFORM/Resources/Library");

end bilinear_eval_extrap;
