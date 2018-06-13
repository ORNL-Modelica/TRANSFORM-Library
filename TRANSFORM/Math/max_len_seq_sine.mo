within TRANSFORM.Math;
function max_len_seq_sine

  input Real weights[:]={1,1,1,1,1,1,1};
  input Integer harmonics[size(weights, 1)]={1,2,4,8,16,32,64};

  output Integer y[integer(max(harmonics)^2)];

protected
  Integer nA=size(weights, 1);
  Integer nT=integer(max(harmonics)^2);
  Real freqHz=1/(2*Modelica.Constants.pi);
  Real t[nT]=linspace(
      0,
      1,
      nT);

  Real x[nT]=zeros(nT);

algorithm

  for i in 1:nT loop
    x[i] := sum({weights[j]*cos(harmonics[j]*t[i]/freqHz) for j in 1:nA});
    y[i] := integer((x[i]/abs(x[i]) + 1)/2);
  end for;

end max_len_seq_sine;
