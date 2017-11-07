within TRANSFORM.Math;
function fillArray_2D
  "create a matrix from an array of values (i.e., fill(val[:],n1,n2)) for 2 dimensions"
  extends Modelica.Icons.Function;

  input Real val[:] "Array of values for use in fill";

  input Integer n1 "Array size (i.e., fill(val[i],n1,n2))";
  input Integer n2 "Array size (i.e., fill(val[i],n1,n2))";

  output Real y[n1,n2,size(val, 1)] "Matrix";

protected
  Integer m=size(val, 1);

algorithm

  for i in 1:m loop
    y[:, :, i] := fill(
      val[i],
      n1,
      n2);
  end for;

end fillArray_2D;
