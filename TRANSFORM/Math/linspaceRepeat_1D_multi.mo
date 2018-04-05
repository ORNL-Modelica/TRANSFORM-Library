within TRANSFORM.Math;
function linspaceRepeat_1D_multi
  "Create [m] linearly spaced 1D arrays stored in a [n,m] matrix and the special case when n = 1 the average is returned"
  extends Modelica.Icons.Function;

  input Real x1[:,:] "First array";
  input Real x2[size(x1,1),size(x1,2)] "Second array";

  input Integer n "Array row size";

  output Real y[n,size(x1,1),size(x1,2)] "Array";

protected
  Integer m1=size(x1,1);
  Integer m2=size(x1,2);
algorithm

  for i in 1:m1 loop
    for j in 1:m2 loop
    y[:,i,j] := linspace_1D(
      x1[i,j],
      x2[i,j],
      n);
    end for;
  end for;

end linspaceRepeat_1D_multi;
