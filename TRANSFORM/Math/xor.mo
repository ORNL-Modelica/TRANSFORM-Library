within TRANSFORM.Math;
function xor
  input Integer u1[:];
  input Integer u2[size(u1, 1)];

  output Integer y[size(u1, 1)];

protected
  Integer n=size(u1, 1);
algorithm

  for i in 1:n loop
    assert(u1[i] == 1 or u1[i] == 0, "u1 has non-binary (1/0) values");
    assert(u2[i] == 1 or u2[i] == 0, "u2 has non-binary (1/0) values");
  end for;

  for i in 1:n loop
    y[i] := if not u1[i] == u2[i] then 1 else 0;
  end for;
end xor;
