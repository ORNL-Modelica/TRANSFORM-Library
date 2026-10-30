within TRANSFORM.Math;
function replaceArrayValues
  "Replace array values with user specified values at specified index"
  extends TRANSFORM.Icons.Function;
  input Real orig[:] "Original array";
  input Integer index[:] "Indices of values to be replaced";
  input Real value[size(index, 1)] "Replacement values";
  output Real new[size(orig, 1)] "Array with replaced values";
protected
  Integer nR=size(index, 1);
algorithm
  new := orig;
  for i in 1:nR loop
    new[index[i]] := value[i];
  end for;
  annotation (Documentation(info="<html>
<p>For example:</p>
<p><span style=\"font-family: Courier New;\">array[:]&nbsp;=&nbsp;{1,2,1,2,1,2};</span></p>
<p><span style=\"font-family: Courier New;\">iReplace[2]&nbsp;=&nbsp;{3,1};</span></p>
<p><span style=\"font-family: Courier New;\">valueR[<span style=\"color: #ff0000;\">size</span>(iReplace,1)]&nbsp;=&nbsp;{-1,-2};</p>
<p><br><span style=\"font-family: Courier New;\">Returns:</span></p>
<p><br><span style=\"font-family: Courier New;\">y = {-2,2,-1,2,1,2};</span></p>
</html>"));
end replaceArrayValues;
