within TRANSFORM.Math.Interpolation;
partial function PartialInterpolation

  extends TRANSFORM.Icons.Function;

  input String tablesPath
    "Path to interpolation tables. Format = '|x.csv|y.csv|z.csv|";
  input Real x;
  input Real y;

  output Real z;

end PartialInterpolation;
