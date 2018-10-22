within TRANSFORM.Math;
function spliceSigmoid "Smoothing algorithm using the sigmoid function"

  input Real below "Result below transition point";
  input Real above "Result above transition point";
  input Real x "Value of interest";
  input Real x0 "Transition or center value";
  input Real k=100 "Transition region factor (larger #s increase slope steepness";

  output Real smoothResult "Smoothed result";

protected
  Real sigmoid "Result of the sigmoid function";

algorithm
  sigmoid :=Sigmoid(
    x,
    x0,
    k);

  if sigmoid <= 0.000000001 then
    sigmoid :=0;
  elseif sigmoid >= 0.999999999 then
    sigmoid :=1;
  else
    sigmoid :=sigmoid;
  end if;

  smoothResult :=(1 - sigmoid)*below + sigmoid*above;

end spliceSigmoid;
