within TRANSFORM.Math;
function max_len_seq
  input Integer seed[:] = {1,0,1};
  input Integer generator[size(seed,1)+1] = {1,1,0,1};

  output Integer y[integer(2^(size(seed,1))-1)];

protected
  Integer nBit = size(seed,1);
  Integer nVal = integer(2^(nBit)-1);
  Integer seed_int[nBit+1] = cat(1,{0},seed);

algorithm

  assert(sum(seed) > 0, "seed must contain at least one 1");

  for i in 1:nVal loop
    y[i] :=seed_int[end];

    for i in 1:nBit loop
      seed_int[i] :=seed_int[i + 1];
    end for;
    seed_int[nBit+1] :=0;

    if seed_int[1] == 1 then
      seed_int := xor(seed_int, generator);
    end if;

  end for;

  annotation (Documentation(info="<html>
<p>Create a PRBS or maximum lenqth sequence binary array. </p>
<p><br>!! Caution: Incorrect generator will cause issues. See scipy.signal.max_len_seq for proper generators based on sequence.</p>
</html>"));
end max_len_seq;
