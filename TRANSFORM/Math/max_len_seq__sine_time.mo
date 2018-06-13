within TRANSFORM.Math;
function max_len_seq__sine_time
  "Return time sequence interval and initial mls value as the last index"

  input Real weights[:]={1,1,1,1,1,1,1};
  input Integer harmonics[size(weights, 1)]={1,2,4,8,16,32,64};
  input Boolean integralTime=true
    "=false for sum(mls_t) = 1 else mls_t[end] = 1";

  output Real mls_t[integer(sum(abs(diff(max_len_seq_sine(weights, harmonics)))))+ 1 + 1] "Time intervals and last index is mls[1]";

protected
  Integer nT=integer(max(harmonics)^2);
  Integer mls[nT]=TRANSFORM.Math.max_len_seq_sine(weights, harmonics);
  Integer nSeq=integer(sum(abs(diff(mls)))) + 1;

  Real dt=1/nT;
  Real summation=0;
  Integer j=1;
  Real mls_t_int[nSeq];

algorithm

  for i in 1:nT - 1 loop
    if mls[i] == mls[i + 1] then
      summation := summation + dt;
    else
      mls_t_int[j] := summation;
      j := j + 1;
      summation := dt;
    end if;

  end for;
  mls_t_int[j] := 1 - sum(mls_t_int);

  if integralTime then
    for i in 1:nSeq loop
      mls_t[i] := sum(mls_t_int[1:i]);
    end for;
  else
    mls_t[1:nSeq] := mls_t_int;
  end if;

  mls_t[nSeq+1] :=mls[1];

end max_len_seq__sine_time;
