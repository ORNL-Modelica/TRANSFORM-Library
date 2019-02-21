within TRANSFORM.Math;
function fillArray_2D
  "create a matrix from an array of values (i.e., fill(val[:],n1,n2)) for 2 dimensions"
  extends TRANSFORM.Icons.Function;
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
  annotation (Documentation(info="<html>
<p>For example:</p>
<p>For n1=3, n2=2, and val={-1,2,3,10}.</p>
<p>The returned matrix is y[3,2,4] where y[1,:,:] is:</p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"0\"><tr>
<td><p align=\"right\">-1</p></td>
<td><p align=\"right\">2</p></td>
<td><p align=\"right\">3</p></td>
<td><p align=\"right\">10</p></td>
</tr>
<tr>
<td><p align=\"right\">-1</p></td>
<td><p align=\"right\">2</p></td>
<td><p align=\"right\">3</p></td>
<td><p align=\"right\">10</p></td>
</tr>
</table>
</html>"));
end fillArray_2D;
