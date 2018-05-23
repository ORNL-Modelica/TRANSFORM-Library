within TRANSFORM.Math;
function max_len_seq_ternary

  input Integer seed[:]={0,1,2};
  input Integer generator[size(seed, 1)]={1,2,2};

  output Integer y[integer(3^(size(seed, 1)) - 1)];

protected
  Integer nBit=size(seed, 1);
  Integer nVal=integer(3^(nBit) - 1);
  Integer seed_int[nBit]=seed;

algorithm

  assert(sum(seed) > 0, "seed must contain at least one 1");

  for i in 1:nVal loop
    y[i] := mod(sum(generator .* seed_int), 3);
  Modelica.Utilities.Streams.print(String(mod(sum(generator .* seed_int), 3)));

    for j in 1:nBit - 1 loop
      seed_int[nBit-j+1] := seed_int[nBit-j];
    end for;
    seed_int[1] := y[i];

  end for;

end max_len_seq_ternary;
