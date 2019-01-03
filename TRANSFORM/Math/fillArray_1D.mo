within TRANSFORM.Math;
function fillArray_1D
  "create a matrix from an array of values (i.e., fill(val[:],n)) for 1 dimension"
  extends Modelica.Icons.Function;

  input Real val[:] "Array of values for use in fill";

  input Integer n "Array size (i.e., fill(val[i],n,n2))";

  output Real y[n,size(val, 1)] "Matrix";

protected
  Integer m=size(val, 1);

algorithm

  for i in 1:m loop
    y[:, i] := fill(val[i], n);
  end for;

  annotation (Documentation(info="<html>
<p>For example:</p>
<p>For n=3, and val={-1,2,3,10}.</p>
<p>The returned matrix is y[3,4]</p>
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
<tr>
<td><p align=\"right\">-1</p></td>
<td><p align=\"right\">2</p></td>
<td><p align=\"right\">3</p></td>
<td><p align=\"right\">10</p></td>
</tr>
</table>
</html>"));
end fillArray_1D;
