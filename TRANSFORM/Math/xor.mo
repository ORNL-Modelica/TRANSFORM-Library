within TRANSFORM.Math;
function xor
  input Integer x1[:];
  input Integer x2[size(x1, 1)];
  output Integer y[size(x1, 1)];
protected
  Integer n=size(x1, 1);
algorithm
  for i in 1:n loop
    assert(x1[i] == 1 or x1[i] == 0, "u1 has non-binary (1/0) values");
    assert(x2[i] == 1 or x2[i] == 0, "u2 has non-binary (1/0) values");
  end for;
  for i in 1:n loop
    y[i] := if not x1[i] ==x2 [i] then 1 else 0;
  end for;
  annotation (Documentation(info="<html>
<p>Computes the truth value of x1 XOR x2 using binary.</p>
<p>Similar to https://docs.scipy.org/doc/numpy-1.15.0/reference/generated/numpy.logical_xor.html except with [1,0];</p>
<p><br>For example:</p>
<p>x1 = {1,0,1,0,0}</p>
<p>x2 = {0,1,1,0,1}</p>
<p>y = {1,1,0,0,1}</p>
</html>"));
end xor;
