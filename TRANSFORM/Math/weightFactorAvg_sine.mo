within TRANSFORM.Math;
function weightFactorAvg_sine


  input Real x[:] "x-value";
  input String shape = "uniform" "Base shape" annotation(choices(choice="uniform",choice="sine"));

  output Real wf[size(x,1)] "weight factor";
protected
  Integer n = size(x,1);
  Real y[n];
  Real integral;

algorithm
  if shape == "uniform" then
    y := ones(n);
  elseif shape == "sine" then
    y :=sin(x);
  end if;

  integral :=TRANSFORM.Math.integral_TrapezoidalRule(x, y);
  wf :=y/integral;

  annotation (Documentation(info="<html>
<p>Computes a sinusoidal weighted fraction whose average is one</p>
</html>"));
end weightFactorAvg_sine;
