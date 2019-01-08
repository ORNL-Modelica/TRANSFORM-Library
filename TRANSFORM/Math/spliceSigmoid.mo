within TRANSFORM.Math;
function spliceSigmoid "Smoothing algorithm using the sigmoid function"

  input Real pos "Result after transition point";
  input Real neg "Result before transition point";
  input Real x "Value of interest (e.g., x = val-x_t)";
  input Real k=100 "Transition region factor (larger #s increase slope steepness)";

  output Real y "Smoothed result";

protected
  Real sigmoid "Result of the sigmoid function";

algorithm
  sigmoid := 1/(1 + exp(-k*x));

  if sigmoid <= 0.000000001 then
    sigmoid :=0;
  elseif sigmoid >= 0.999999999 then
    sigmoid :=1;
  else
    sigmoid :=sigmoid;
  end if;

  y :=(1 - sigmoid)*neg + sigmoid*pos;

  annotation(smoothOrder=4, Documentation(info="<html>
<p><img src=\"modelica://TRANSFORM/Resources/Images/Information/spliceSigmoid.jpg\"/></p>
</html>"));
end spliceSigmoid;
