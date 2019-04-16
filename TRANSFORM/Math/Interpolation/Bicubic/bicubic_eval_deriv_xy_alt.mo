within TRANSFORM.Math.Interpolation.Bicubic;
function bicubic_eval_deriv_xy_alt
  "Bicubic (2D) interpolation for table double derivative wrt x and y (same as y and x) [SAME AS *_eval_deriv_xy but derivative formatting]. Throws error outside of table range."
  extends TRANSFORM.Icons.Function;
  input String tablesPath
    "Path to interpolation tables. Format = '|x.csv|y.csv|z.csv|";
  input Real x;
  input Real y;
  input Real dx;
  input Real dy;
  output Real z;
external"C" z = bicubic_eval_deriv_xy(
    tablesPath,
    x,
    y) annotation (
    Include="#include \"noname.h\"",
    Library={"noname","gsl"},
    IncludeDirectory="modelica://TRANSFORM/Resources/Include",
    LibraryDirectory="modelica://TRANSFORM/Resources/Library");
end bicubic_eval_deriv_xy_alt;
