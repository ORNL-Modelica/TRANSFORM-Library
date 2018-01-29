within TRANSFORM.Math;
function replaceArrayValues
  "Replace array values with user specified values at specified index"

  input Real[:] array_orig "Original array";
  input Integer[:] iReplace "Indices of values to be replaced";
  input Real[size(iReplace,1)] valueR "Replacement values";

  output Real[size(array_orig,1)] array_new "Array with replaced values";

protected
  Integer nR = size(iReplace,1);

algorithm

  array_new := array_orig;

  for i in 1:nR loop
    array_new[iReplace[i]] :=valueR[i];
  end for;

end replaceArrayValues;
