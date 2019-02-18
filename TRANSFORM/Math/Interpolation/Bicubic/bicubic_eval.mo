within TRANSFORM.Math.Interpolation.Bicubic;
function bicubic_eval
  "Bicubic (2D) interpolation. Throws error outside of table range."
  extends Interpolation.PartialInterpolation;
external"C" z = bicubic_eval(
      tablesPath,
      x,
      y) annotation (
    Include="#include \"noname.h\"",
    Library="noname",
    IncludeDirectory="modelica://TRANSFORM/Resources/Include",
    LibraryDirectory="modelica://TRANSFORM/Resources/Library");
end bicubic_eval;
