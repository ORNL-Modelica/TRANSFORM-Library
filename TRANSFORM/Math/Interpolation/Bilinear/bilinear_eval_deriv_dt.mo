within TRANSFORM.Math.Interpolation.Bilinear;
function bilinear_eval_deriv_dt
  "Bilinear (2D) interpolation for table derivative wrt time. Throws error outside of table range."
  extends TRANSFORM.Icons.Function;
  input String tablesPath
    "Path to interpolation tables. Format = '|x.csv|y.csv|z.csv|";
  input Real x;
  input Real y;
  input Real dx;
  input Real dy;
  output Real z;
algorithm
  // Chain rule
  z :=TRANSFORM.Math.Interpolation.Bilinear.bilinear_eval_deriv_x(tablesPath,x,y)*dx
 + TRANSFORM.Math.Interpolation.Bilinear.bilinear_eval_deriv_y(tablesPath,x,y)*dy;

end bilinear_eval_deriv_dt;
