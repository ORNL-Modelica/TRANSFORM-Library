within TRANSFORM.Math;
function linspaceRepeat_1D
  "Create [m] linearly spaced 1D arrays stored in a [n,m] matrix and the special case when n = 1 the average is returned"
  extends Modelica.Icons.Function;

  input Real x1[:] "First array";
  input Real x2[size(x1,1)] "Second array";

  input Integer n "Array row size";

  output Real y[n,size(x1,1)] "Array";

protected
    Integer m=size(x1,1);
algorithm

  for i in 1:m loop
    y[:,i] := linspace_1D(
      x1[i],
      x2[i],
      n);
  end for;

end linspaceRepeat_1D;
